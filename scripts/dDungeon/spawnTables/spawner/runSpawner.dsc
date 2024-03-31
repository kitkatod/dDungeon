dd_SpawnTables_RunSpawner:
    debug: false
    type: task
    definitions: spawnerLoc
    script:
    #Skip if chunk not loaded
    - if !<[spawnerLoc].chunk.is_loaded>:
        - stop

    #Get spawner's data
    - define spawnerData <[spawnerLoc].flag[dd_spawner]>

    #Skip if it's a null spawner
    - if <[spawnerLoc].flag[dd_spawner.spawn_table]> == NULL_TABLE:
        - stop

    #Update BossBar if it is enabled
    - if <[spawnerData.bossbar_enabled].if_null[false]>:
        - ~run dc_SpawnTables_UpdateSpawnerBossbar def.spawnerLoc:<[spawnerLoc]>

    #Remove references if spawner is no longer needed.
    - if <[spawnerData.bank]> != null && <[spawnerData.currentBank]> <= 0 && <[spawnerData.spawnedSpawnPoints].if_null[0]> <= 0 && <[spawnerData.bossbarPlayers].is_empty>:
        - flag <[spawnerLoc].world> dd_spawnerLocs:<-:<[spawnerLoc]>
        - flag <[spawnerLoc]> dd_spawner:!
        - stop

    #Skip spawning for spawner if existing spawner point count is high enough
    - if <[spawnerData.currentlySpawnedPoints]> >= <[spawnerData.area_max]>:
        - stop

    #Check activation radius, or world for players. If no players, stop.
    - if <[spawnerData.activation_radius]> >= 0:
        - define radiusPlayers <[spawnerLoc].find_players_within[<[spawnerData.activation_radius]>].filter_tag[<[filter_value].gamemode.equals[SURVIVAL]>]>
    - else:
        - define radiusPlayers <[spawnerLoc].world.players.filter_tag[<[filter_value].gamemode.equals[SURVIVAL]>]>

    - if <[radiusPlayers].is_empty>:
        - stop

    #Determine number of Spawn Points to use based on the lower of budget or currentBank
    - define spawnPointsMax <[spawnerData.budget]>
    - if <[spawnerData.currentBank]> != null && <[spawnerData.currentBank]> < <[spawnPointsMax]>:
        - define spawnPointsMax <[spawnerData.currentBank]>


    #Find nearby spawnable points
    - define spawningLocs <[spawnerLoc].center.find_spawnable_blocks_within[<[spawnerData.spawn_radius]>]>

    #Ignore spawnable points that are within a spawning blocker (specifcally only NULL_TABLE spawn table spawners)
    - define nearbySpawners <[spawnerLoc].find_blocks_flagged[dd_spawner].within[30].exclude[<[spawnerLoc]>]>
    - foreach <[nearbySpawners]> as:spawnerLoc:
        - if <[spawnerLoc].flag[dd_spawner.spawn_table]> == NULL_TABLE:
            - foreach <[spawningLocs]> as:spawnLoc:
                - if <[spawnerLoc].distance[<[spawnLoc]>]> <= <[spawnerLoc].flag[dd_spawner.spawn_radius]>:
                    - define spawningLocs:<-:<[spawnLoc]>

    #Exclude points that are too close to any player (don't spawn on top of them)
    #, or outside dungeon area
    - foreach <[spawningLocs]> as:spawnLoc:
        - if !<[spawnLoc].find_players_within[2].is_empty>:
            - define spawningLocs:<-:<[spawnLoc]>
        - if !<[spawnerLoc].world.flag[dd_area].contains[<[spawnLoc]>]>:
            - define spawningLocs:<-:<[spawnLoc]>

    #Skip spawning if there aren't valid points
    - if <[spawningLocs].is_empty>:
        - stop

    #Do the spawn!
    - define spawnLoc <[spawningLocs].random>
    - ~run dd_rollSpawnTable def.loc:<[spawnLoc]> def.spawnTable:<[spawnerData.spawn_table]> def.targetSpawnPoints:<[spawnPointsMax]> def.spawnRadius:<[spawnerData.spawn_radius]> save:spawnRun
    - define spawningResults <entry[spawnRun].created_queue.determination.first.if_null[null]>

    #Skip if spawningResults was null for some reason
    - if <[spawningResults]> == null:
        - stop

    #Run particle effects
    - run dd_SpawnTables_SpawnerEffects def.loc:<[spawnerLoc]>

    #Track each entity that has spawned
    - foreach <[spawningResults.entities]> as:entity:
        - flag <[entity]> dd_spawner_location:<[spawnerLoc]>
        - flag <[spawnerLoc]> dd_spawner.entities:->:<[entity]>
        - flag <[spawnerLoc]> dd_spawner.currentlySpawnedPoints:+:<[entity].flag[dd_spawnPoints].if_null[0]>

    #Update currentBank if needed
    - if <[spawnerData.currentBank]> != null:
        - flag <[spawnerLoc]> dd_spawner.currentBank:-:<[spawningResults.spawnedSpawnPoints]>
