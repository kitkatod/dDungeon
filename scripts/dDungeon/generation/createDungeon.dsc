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
    - define world <world[<[worldName]>]>
    - flag <[world]> "dd_currentGenerationStep:Creating World"

    #Get Dungeon Settings
    - define dungeonSettings <script[dd_DungeonSettings].data_key[dungeons].get[<[dungeonType]>]>

    #Fire custom event for world created
    - definemap context world:<[world]> dungeon_key:<[dungeonKey]> dungeon_category:<[dungeonSettings.category]>
    - customevent id:dd_dungeon_world_created context:<[context]>

    #Setup processing flags
    - flag <[world]> dd_DungeonKey:<[dungeonKey]>
    - flag server dd_DungeonWorlds.<[dungeonKey]>:<[worldName]>
    - flag <[world]> sectionCounts:<map[]>
    - flag <[world]> dd_DungeonSettings:<[dungeonSettings]>
    - flag <[world]> dd_generationRunning:true
    - flag <[world]> dd_allowSpawning:false
    - flag <[world]> dd_startTime:<[startTime]>
    - flag <[world]> dd_loadedSchematics:<list[]>
    - flag <[world]> dd_pathway_queue:<list[]>
    - flag <[world]> dd_inventory_queue:<list[]>
    - flag <[world]> dd_all_inventories:<list[]>
    - flag <[world]> dd_specialLootTables:<map[]>
    - flag <[world]> dd_spawnerLocs:<list[]>
    - flag <[world]> dd_sectionCount:1
    - flag <[world]> dd_inventoryCount:0

    #Do basic setup of new world
    - run dd_SetupAttributeModifiers def.world:<[world]>
    - gamerule <[world]> doMobSpawning false
    - gamerule <[world]> doDaylightCycle false
    - adjust <[world]> time:18000

    #Run monitor task in background if it was requested
    - if <[monitor].if_null[false]>:
        - run dd_create_monitorgeneration def.world:<[world]> def.players:<player>

    #Start loading all schematics
    - run dd_Schematic_LoadAll def.world:<[world]> def.category:<[dungeonSettings.category]> save:queueLoadSchematics

    #Prepare section data for the world
    - flag <[world]> "dd_currentGenerationStep:Preparing Data"
    - run dd_SectionDataCache_Prepare def.world:<[world]> save:queuePrepareData

    - waituntil !<entry[queuePrepareData].created_queue.is_valid> rate:5t max:1m
    - waituntil !<entry[queueLoadSchematics].created_queue.is_valid> rate:5t max:1m

    #Place a Spawn Room
    - ~run dd_Create_SpawnRoom def.world:<[world]>

    #Move players into dungeon spawn
    - define entrancePoint <[world].flag[dd_DungeonSettings.entrancePoint]>
    - run dd_EnterDungeon def.dungeonKey:<[dungeonKey]> def.exitLocation:<player.location>

    #Process all pathways
    - flag <[world]> "dd_currentGenerationStep:Processing Pathways"
    - define maxSections <[dungeonSettings.section_count_hard_max].if_null[500]>
    - ~run dd_Create_Pathways def.world:<[world]> def.maxSections:<[maxSections]>

    #Cleanup loaded schematics in memory
    - ~run dd_Schematic_UnloadAll def.world:<[world]>

    #Process all queued inventories
    - flag <[world]> "dd_currentGenerationStep:Processing Inventories"
    - ~run dd_Create_Inventories def.world:<[world]>

    #Backfill Sections
    - if <[dungeonSettings.backfill_dungeon].if_null[true]>:
        - flag <[world]> "dd_currentGenerationStep:Backfilling Sections"
        - ~run dd_BackfillSections def.world:<[world]> def.material:<[dungeonSettings.backfill_dungeon_material].if_null[stone]>

    #Prepare world for possible player use
    - flag <[world]> dd_area:<cuboid[<[world].name>_dcarea]>
    - gamerule <[world]> doMobSpawning true
    - flag <[world]> dd_allowSpawning:true
    - flag <[world]> dd_spawnerLocs:<list[]>

    #Get references to all dungeon spawners
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

    #Bulk backfill space outside dungeon
    - if <[dungeonSettings.backfill_dungeon].if_null[true]>:
        - announce "<gold> *** Dungeon can now be considered ready for use. Backfill will continue but should not impact players."
        - define backfillStartTime <util.time_now>
        - flag <[world]> "dd_currentGenerationStep:Backfilling World"
        - ~run dd_BackfillWorld def.world:<[world]> def.material:<[dungeonSettings.backfill_dungeon_material].if_null[stone]>
        - announce "<gold> *** World backfill completed in additional <util.time_now.duration_since[<[backfillStartTime]>].formatted>"

    #Cleanup any remaining data
    - ~run dd_SectionDataCache_Unload def.world:<[world]>
    - note remove as:<[world].name>_dcarea
    - flag <[world]> dd_generationRunning:false
    - flag <[world]> dd_startTime:!

    #Announce completion
    - announce "<gold> *** Total generation took <util.time_now.duration_since[<[startTime]>].formatted> "

    #Fire custom event for Dungeon Generation Complete
    - definemap context world:<[world]> dungeon_key:<[dungeonKey]> dungeon_category:<[dungeonSettings.category]>
    - customevent id:dd_dungeon_generation_complete context:<[context]>
