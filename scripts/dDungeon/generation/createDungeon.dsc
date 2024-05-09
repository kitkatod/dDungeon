dd_Create:
    debug: false
    type: task
    definitions: dungeonType|monitor|dungeonKey
    script:
    - define startTime <util.time_now>
    - if !<[monitor].exists>:
        - define monitor false

    - if !<[dungeonKey].exists>:
        - narrate "<red> *** ERROR: dungeonKey was not supplied"
        - stop

    #Wipe existing dungeon world if it exists
    - if <server.flag[dd_DungeonWorlds.<[dungeonKey]>].exists>:
        - define currentWorld <server.flag[dd_DungeonWorlds.<[dungeonKey]>].as[world]>
        - narrate "<red> *** Destroying existing <[currentWorld].name> world"
        - ~run dd_BreakdownWorld def.world:<[currentWorld]>

    #Get a new world name (making this dynamic due to some world internals still processing for some time after the world is destroyed for whatever reason...)
    #(Just making a totally new world name each time seems easier...)
    - define worldName dDungeon_<[dungeonKey]>_<util.random_uuid.replace[-]>

    #Create a new world
    - createworld <[worldName]> generator:denizen:void
    - waituntil <server.worlds.parse_tag[<[parse_value].name>].contains[<[worldName]>]> max:10s rate:1s

    #Waiting another couple seconds... Bukkit sometimes freaks out saying the referenced world is null... An aditional slight pause seems to help...
    - wait 2s

    #Get Dungeon Settings
    - define dungeonSettings <script[dd_DungeonSettings].data_key[dungeons].get[<[dungeonType]>]>

    #Get World Reference
    - define world <world[<[worldName]>]>
    - flag <[world]> dd_DungeonKey:<[dungeonKey]>
    - flag server dd_DungeonWorlds.<[dungeonKey]>:<[worldName]>
    - flag <[world]> sectionCounts:<map[]>
    - flag <[world]> dd_DungeonSettings:<[dungeonSettings]>
    - flag <[world]> dd_generationRunning:true
    - flag <[world]> dd_allowSpawning:false
    - flag <[world]> "dd_currentGenerationStep:Creating World"
    - flag <[world]> dd_startTime:<[startTime]>
    - flag <[world]> dd_loadedSchematics:<list[]>
    - flag <[world]> dd_pathway_queue:<list[]>
    - flag <[world]> dd_inventory_queue:<list[]>
    - flag <[world]> dd_all_inventories:<list[]>
    - flag <[world]> dd_specialLootTables:<map[]>
    - flag <[world]> dd_spawnerLocs:<list[]>

    - run dd_SetupAttributeModifiers def.world:<[world]>

    - gamerule <[world]> doMobSpawning false
    - gamerule <[world]> doDaylightCycle false
    - adjust <[world]> time:18000

    - if <[monitor].if_null[false]>:
        - run dd_create_monitorgeneration def.world:<[world]> def.players:<player>

    #Start loading all schematics
    - run dd_Schematic_LoadAll def.world:<[world]> def.category:<[dungeonSettings.category]> save:queueLoadSchematics

    #Prepare section data for the world
    - flag <[world]> "dd_currentGenerationStep:Preparing Data"
    - run dd_SectionDataCache_Prepare def.world:<[world]> save:queuePrepareData

    #Set location where dungeon will be built
    - define loc <location[0,64,0,0,0,<[worldName]>]>

    #Pick a spawn room
    - define sectionName <[dungeonSettings.category].proc[dd_GetFilesList].context[spawn_room].random>

    - waituntil !<entry[queuePrepareData].created_queue.is_valid> rate:5t max:1m
    - waituntil !<entry[queueLoadSchematics].created_queue.is_valid> rate:5t max:1m

    #Get sectionData for the spawn room
    - define sectionOptions <[world].flag[dd_sectionData.<[dungeonSettings.category]>.spawn_room.<[sectionName].after_last[/]>]>

    #Load a spawn schematic
    #Make sure the area is loaded incase we move far away from the origin
    - ~run dd_LoadAreaChunks def:<[loc].chunk>|8|5s

    #Randomly flip the spawn room to add variability
    - define flip <util.random_boolean>
    - if <[flip]>:
        - define sectionOptions <[sectionOptions].proc[dd_Transform_FlipOverX]>
        - ~run dd_Schematic_SetOrientation def.schemPath:<[sectionName]> def.flip:<[flip]> def.rotation:0

    #Paste the spawn section and undo orientation
    - ~schematic paste name:<[sectionName]> <[loc]>
    - flag <[loc]> dd_SectionOptions.readonly:true
    - ~run dd_Schematic_UndoOrientation def.schemPath:<[sectionName]> def.flip:<[flip]> def.rotation:0

    #Get area of pasted section, handle any post transforms
    - define cuboid <[loc].add[<[sectionOptions.pos1]>].to_cuboid[<[loc].add[<[sectionOptions.pos2]>]>]>

    #Fire custom event for Section being placed
    - definemap context area:<[cuboid]> dungeon_key:<[dungeonKey]> dungeon_category:<[dungeonSettings.category]> dungeon_section_type:spawn_room dungeon_section_name:<[sectionOptions.name]>
    - customevent id:dd_dungeon_section_placed context:<[context]>

    #Run dungeon specific custom noise generation if it is specified
    - if <[dungeonSettings.noise_generation_task].exists>:
        - define taskScript <[dungeonSettings.noise_generation_task].as[script].if_null[null]>
        - if <[taskScript]> != null && <[taskScript].data_key[type]> == task:
            - ~run <[taskScript]> def.cuboid:<[cuboid]> def.type:spawn_room

    - note <[cuboid]> as:<[world].name>_dcarea

    #Move players into dungeon spawn
    - if <[sectionOptions.entrancePoint].exists>:
        - define tpLoc <[loc].add[<[sectionOptions.entrancePoint]>].if_null[<[loc].up[1]>]>
        - define tpLoc <[tpLoc].with_pitch[<[sectionOptions.entrancePoint].pitch>].with_yaw[<[sectionOptions.entrancePoint].yaw>]>
        - flag <[world]> dd_DungeonSettings.entrancePoint:<[tpLoc]>
    - else:
        - flag <[world]> dd_DungeonSettings.entrancePoint:<[loc].up[1]>

    - define entrancePoint <[world].flag[dd_DungeonSettings.entrancePoint]>
    - run dd_EnterDungeon def.dungeonKey:<[dungeonKey]> def.exitLocation:<player.location>

    - define dungeonExitRadius <[sectionOptions.exitRadius].if_null[5]>
    - define dungeonExitArea <[entrancePoint].to_cuboid[<[entrancePoint]>].expand[<[dungeonExitRadius]>]>
    - note <[dungeonExitArea]> as:dd_exitArea_<[world].name>
    - flag <cuboid[dd_exitArea_<[world].name>]> dd_exitArea

    #Queue pathways off of spawn area
    - ~run dd_QueuePathways def.loc:<[loc]> def.sectionOptions:<[sectionOptions]>

    #Queue inventories in spawn area
    - ~run dd_QueueInventories def.loc:<[loc]> def.sectionOptions:<[sectionOptions]>

    #Fill inventories in the spawn section
    #- run dg_processInventories def.loc:<[loc]> def.sectionOptions:<[sectionOptions]>

    #Section and inventories placed count
    - flag <[world]> dd_sectionCount:1
    - flag <[world]> dd_inventoryCount:0

    - define buildBuffer <[dungeonSettings.allowed_build_space].if_null[40]>
    - flag <[world]> dd_allowedArea:<[cuboid].with_min[<[cuboid].min.with_y[-30]>].with_max[<[cuboid].max.with_y[280]>].expand[<[buildBuffer]>,0,<[buildBuffer]>]>

    - flag <[world]> "dd_currentGenerationStep:Processing Pathways"

    #Process all pathways
    - define maxSections <[dungeonSettings.section_count_hard_max].if_null[500]>
    - ~run dd_Create_Pathways def.world:<[world]> def.maxSections:<[maxSections]>

    #Cleanup loaded schematics in memory
    - ~run dd_Schematic_UnloadAll def.world:<[world]>
    - flag <[world]> "dd_currentGenerationStep:Processing Inventories"

    #Process all queued inventories
    - ~run dd_Create_Inventories def.world:<[world]>

    - flag <[world]> "dd_currentGenerationStep:Backfilling Sections"
    - ~run dd_BackfillSections def.world:<[world]>

    - flag <[world]> dd_area:<cuboid[<[world].name>_dcarea]>
    - gamerule <[world]> doMobSpawning true
    - flag <[world]> dd_allowSpawning:true
    - flag <[world]> dd_spawnerLocs:<list[]>

    - foreach <[world].flag[dd_area].blocks_flagged[dd_spawner]> as:spawnerLoc:
        - flag <[spawnerLoc]> dd_spawner.currentBank:<[spawnerLoc].flag[dd_spawner.bank]>
        - flag <[spawnerLoc]> dd_spawner.bossbarId:<util.random_uuid>
        - flag <[spawnerLoc]> dd_spawner.currentlySpawnedPoints:0
        - flag <[spawnerLoc]> dd_spawner.bossbarPlayers:<list[]>
        - flag <[world]> dd_spawnerLocs:->:<[spawnerLoc]>

    #At this point we can consider the dungeon "ready".
    #Backfilling the larger area takes a bit of time, but everything else should be ready for players, and filling in the world shouldn't impact normal players
    #Announce stats
    - announce "<gold> *** Generation completed in <util.time_now.duration_since[<[startTime]>].formatted>"
    - announce "<gold> *** Placed <[world].flag[dd_sectionCount]> sections"
    - announce "<gold> *** Rolled loot for <[world].flag[dd_inventoryCount]> inventories"
    - announce "<gold> *** Dungeon can now be considered ready for use. Backfill will continue but should not impact players."

    - define backfillStartTime <util.time_now>
    - flag <[world]> "dd_currentGenerationStep:Backfilling World"
    - ~run dd_BackfillWorld def.world:<[world]>
    - announce "<gold> *** World backfill completed in additional <util.time_now.duration_since[<[backfillStartTime]>].formatted>"
    - announce "<gold> *** Total generation took <util.time_now.duration_since[<[startTime]>].formatted> "


    - ~run dd_SectionDataCache_Unload def.world:<[world]>
    - note remove as:<[world].name>_dcarea

    - flag <[world]> dd_generationRunning:false
    - flag <[world]> dd_startTime:!
