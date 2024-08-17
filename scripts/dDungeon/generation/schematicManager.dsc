dd_Schematic_Load:
    debug: false
    type: task
    definitions: world|schemPath
    script:
    - define schemName <[world].name>_<[schemPath]>
    - if <schematic[<[schemName]>].exists>:
        - stop
    # - if <[world].flag[dd_loadedSchematics].contains_single[<[schemPath]>].if_null[false]>:
    #     - stop
    - ~schematic load name:<[schemName]> filename:dDungeon/<[schemPath]>
    - flag <[world]> dd_loadedSchematics:->:<[schemName]>


dd_Schematic_SetOrientation:
    debug: false
    type: task
    definitions: world|schemPath|flip|rotation
    script:
    - define schemName <[world].name>_<[schemPath]>
    - if <[flip]>:
        - ~schematic flip_z name:<[schemName]>
    - ~schematic rotate name:<[schemName]> angle:<[rotation]>

dd_Schematic_UndoOrientation:
    debug: false
    type: task
    definitions: world|schemPath|flip|rotation
    script:
    - define schemName <[world].name>_<[schemPath]>
    - ~schematic rotate name:<[schemName]> angle:-<[rotation]>
    - if <[flip]>:
        - ~schematic flip_z name:<[schemName]>

dd_Schematic_LoadAll:
    debug: false
    type: task
    definitions: world|category
    script:
    #Save a timestamp to compare against. Pause for a tick if we're spending more than 1 tick doing this.
    - define checkTime <util.time_now>

    - define queueList <list[]>
    - foreach <util.list_files[schematics/dDungeon/<[category]>]> as:type:
        - if <[type].starts_with[_]>:
            - foreach next
        - foreach <util.list_files[schematics/dDungeon/<[category]>/<[type]>]> as:file:
            #If we're spending too much time, wait a tick to slow down a bit
            - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
                - wait 1t
                - define checkTime <util.time_now>

            - if <[file].starts_with[_]> || !<[file].ends_with[.schem]>:
                - foreach next
            - define schemPath <[category]>/<[type]>/<[file].before[.schem]>
            - run dd_Schematic_Load def.world:<[world]> def.schemPath:<[schemPath]> save:loadQueue
            - define queueList:->:<entry[loadQueue].created_queue>

dd_Schematic_UnloadAll:
    debug: false
    type: task
    definitions: world
    script:
    #Save a timestamp to compare against. Pause for a tick if we're spending more than 1 tick doing this.
    - define checkTime <util.time_now>

    #Unload each schematic
    - foreach <[world].flag[dd_loadedSchematics].if_null[<list[]>]> as:schemName:
        #If we're spending too much time, wait a tick to slow down a bit
        - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
            - wait 1t
            - define checkTime <util.time_now>
        - ~schematic unload name:<[schemName]>
    - flag <[world]> dd_loadedSchematics:!