dd_Schematic_Load:
    debug: false
    type: task
    definitions: world|schemPath
    script:
    - if <schematic[<[schemPath]>].exists>:
        - stop
    # - if <[world].flag[dd_loadedSchematics].contains_single[<[schemPath]>].if_null[false]>:
    #     - stop
    - ~schematic load name:<[schemPath]> filename:dDungeon/<[schemPath]>
    - flag <[world]> dd_loadedSchematics:->:<[schemPath]>


dd_Schematic_SetOrientation:
    debug: false
    type: task
    definitions: schemPath|flip|rotation
    script:
    - if <[flip]>:
        - ~schematic flip_z name:<[schemPath]>
    - ~schematic rotate name:<[schemPath]> angle:<[rotation]>

dd_Schematic_UndoOrientation:
    debug: false
    type: task
    definitions: schemPath|flip|rotation
    script:
    - ~schematic rotate name:<[schemPath]> angle:-<[rotation]>
    - if <[flip]>:
        - ~schematic flip_z name:<[schemPath]>

dd_Schematic_LoadAll:
    debug: false
    type: task
    definitions: world|category
    script:
    - define queueList <list[]>
    - foreach <util.list_files[schematics/dDungeon/<[category]>]> as:type:
        - if <[type].starts_with[_]>:
            - foreach next
        - foreach <util.list_files[schematics/dDungeon/<[category]>/<[type]>]> as:file:
            - if <[file].starts_with[_]> || !<[file].ends_with[.schem]>:
                - foreach next
            - define schemPath <[category]>/<[type]>/<[file].before[.schem]>
            - run dd_Schematic_Load def.world:<[world]> def.schemPath:<[schemPath]> save:loadQueue
            - define queueList:->:<entry[loadQueue].created_queue>
    - wait 1s

    # #Loop and check all listed load queues until they all finish
    # - while !<[queueList].is_empty>:
    #     - foreach <[queueList]> as:queue:
    #         #Remove the queue once it has completed
    #         - if <[queue].is_valid.if_null[null]> == null:
    #             - debug LOG <[queue].state>
    #         - if !<[queue].is_valid>:
    #             - define queueList:<-:<[queue]>
    #     - wait 10t

dd_Schematic_UnloadAll:
    debug: false
    type: task
    definitions: world
    script:
    - foreach <[world].flag[dd_loadedSchematics].if_null[<list[]>]> as:schemName:
        - ~schematic unload name:<[schemName]>
    - flag <[world]> dd_loadedSchematics:!