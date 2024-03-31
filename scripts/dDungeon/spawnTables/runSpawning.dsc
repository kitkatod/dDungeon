dd_SpawnTables_world:
    debug: false
    type: world
    events:
        #Run "dungeon ambient" spawning
        on delta time secondly every:5:
        - foreach <server.worlds> as:world:
            - if !<[world].has_flag[dd_DungeonSettings]> || !<[world].flag[dd_allowSpawning].if_null[false]>:
                - foreach next

            - run dd_SpawnTables_AmbientSpawning def.world:<[world]>
            - run dd_SpawnTables_SpawnerSpawning def.world:<[world]>