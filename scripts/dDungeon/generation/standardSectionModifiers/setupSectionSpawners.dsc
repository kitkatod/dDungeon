dd_StandardSectionModifiers_SetupSectionSpawners:
    debug: false
    type: task
    definitions: area
    script:
    #Get references to all dungeon spawners
    - foreach <[area].blocks_flagged[dd_spawner]> as:spawnerLoc:
        - if !<[area].world.flag[dd_spawnerLocs].contains[<[spawnerLoc]>]>:
            - flag <[spawnerLoc]> dd_spawner.currentBank:<[spawnerLoc].flag[dd_spawner.bank]>
            - flag <[spawnerLoc]> dd_spawner.bossbarId:<util.random_uuid>
            - flag <[spawnerLoc]> dd_spawner.currentlySpawnedPoints:0
            - flag <[spawnerLoc]> dd_spawner.bossbarPlayers:<list[]>
            - flag <[area].world> dd_spawnerLocs:->:<[spawnerLoc]>