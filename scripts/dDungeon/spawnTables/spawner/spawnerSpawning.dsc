dd_SpawnTables_SpawnerSpawning:
    debug: false
    type: task
    definitions: world
    script:
    - define spawnerLocs <[world].flag[dd_spawnerLocs]>
    - foreach <[spawnerLocs]> as:spawnerLoc:
        - run dd_SpawnTables_RunSpawner def.spawnerLoc:<[spawnerLoc]>