dd_Create_SpawnRoom:
    debug: false
    type: task
    definitions: world
    script:
    #Get dungeon settings
    - define dungeonSettings <[world].flag[dd_dungeonSettings]>
    #Set location where dungeon will be built
    - define loc <location[0,64,0,0,0,<[world].name>]>
    #Pick a spawn room
    - define sectionName <[dungeonSettings.category].proc[dd_GetFilesList].context[spawn_room].random>

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

    #Apply modified section options back to origin
    - flag <[loc]> dd_SectionOptions:<[sectionOptions]>
    - flag <[loc]> dd_SectionOptions.readonly:true
    - ~run dd_Schematic_UndoOrientation def.schemPath:<[sectionName]> def.flip:<[flip]> def.rotation:0

    #Get area of pasted section, handle any post transforms
    - define cuboid <[loc].add[<[sectionOptions.pos1]>].to_cuboid[<[loc].add[<[sectionOptions.pos2]>]>]>

    #Fire custom event for Section being placed
    - definemap context area:<[cuboid]> dungeon_key:<[world].flag[dd_DungeonKey]> dungeon_category:<[dungeonSettings.category]> dungeon_section_type:spawn_room dungeon_section_name:<[sectionOptions.name]>
    - customevent id:dd_dungeon_section_placed context:<[context]>

    #Run dungeon specific custom noise generation if it is specified
    - if <[dungeonSettings.noise_generation_task].exists>:
        - define taskScript <[dungeonSettings.noise_generation_task].as[script].if_null[null]>
        - if <[taskScript]> != null && <[taskScript].data_key[type]> == task:
            - ~run <[taskScript]> def.cuboid:<[cuboid]> def.type:spawn_room

    #Save noted area of entire dungeon
    - note <[cuboid]> as:<[world].name>_dcarea

    #Setup Entrance point for dungeon spawn room
    - if <[sectionOptions.entrancePoint].exists>:
        - define tpLoc <[loc].add[<[sectionOptions.entrancePoint]>].if_null[<[loc].up[1]>]>
        - define tpLoc <[tpLoc].with_pitch[<[sectionOptions.entrancePoint].pitch>].with_yaw[<[sectionOptions.entrancePoint].yaw>]>
        - define entrancePoint <[tpLoc]>
    - else:
        - define entrancePoint <[loc].up[1]>

    - flag <[world]> dd_DungeonSettings.entrancePoint:<[entrancePoint]>

    #Setup exit area for dungeon spawn room
    - define dungeonExitRadius <[sectionOptions.exitRadius].if_null[5]>
    - define dungeonExitArea <[entrancePoint].to_cuboid[<[entrancePoint]>].expand[<[dungeonExitRadius]>]>
    - note <[dungeonExitArea]> as:dd_exitArea_<[world].name>
    - flag <cuboid[dd_exitArea_<[world].name>]> dd_exitArea

    #Queue pathways off of spawn area
    - ~run dd_QueuePathways def.loc:<[loc]> def.sectionOptions:<[sectionOptions]>

    #Queue inventories in spawn area
    - ~run dd_QueueInventories def.loc:<[loc]> def.sectionOptions:<[sectionOptions]>

    #Setup allowed build area
    - define buildBuffer <[dungeonSettings.allowed_build_space].if_null[40]>
    - flag <[world]> dd_allowedArea:<[cuboid].with_min[<[cuboid].min.with_y[-30]>].with_max[<[cuboid].max.with_y[280]>].expand[<[buildBuffer]>,0,<[buildBuffer]>]>