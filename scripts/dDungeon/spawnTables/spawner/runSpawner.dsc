dd_SpawnTables_RunSpawner:
    debug: false
    type: task
    definitions: spawnerLoc
    script:
    #Skip if chunk not loaded
    - if !<[spawnerLoc].chunk.is_loaded>:
        - stop

    #Get spawner's data
    - define spawnerData <[spawnerLoc].flag[dd_spawner].if_null[null]>

    #Check if block doesn't have spawner flag
    - if <[spawnerData]> == null:
        - stop

    #Skip if it's a null spawner
    - if <[spawnerLoc].flag[dd_spawner.spawn_table]> == NULL_TABLE:
        - stop

    #Update BossBar if it is enabled
    - if <[spawnerData.bossbar_enabled].if_null[false]>:
        - ~run dc_SpawnTables_UpdateSpawnerBossbar def.spawnerLoc:<[spawnerLoc]>

    #Remove references if spawner is no longer needed.
    - if <[spawnerData.bank]> != null && <[spawnerData.currentBank]> <= 0 && <[spawnerData.currentlySpawnedPoints].if_null[0]> <= 0 && <[spawnerData.bossbarPlayers].is_empty>:
        - flag <[spawnerLoc].world> dd_spawnerLocs:<-:<[spawnerLoc]>

        # Spawner is about to be deleted. Fire custom event before spawner is gone.
        - definemap context location:<[spawnerLoc]> players:<[spawnerData.assisting_players].if_null[<list[]>]> spawn_table:<[spawnerData.spawn_table]>
        - customevent id:dd_dungeon_spawner_destroyed context:<[context]>

        # Remove the spawner
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

    #Skip if allowed spawn points is zero
    - if <[spawnPointsMax]> <= 0:
        - stop


    #Pick a random offset within the spawn_radius, then find spawnable blocks nearby that offset.
    #This is done to reduce the performance hit if spawn_radius is high enough to be searching a large area (40 seems to cause TPS hits)
    - define randomOffsetLoc <[spawnerLoc].center.random_offset[<[spawnerData.spawn_radius]>].center>

    #Find nearby spawnable points within the spawn_radius, or within 5 if spawn_radius is more than 5
    - define spawningLocs <[randomOffsetLoc].find_spawnable_blocks_within[<[spawnerData.spawn_radius].min[5]>]>

    #Exclude points that are outside dungeon area
    - foreach <[spawningLocs]> as:spawnLoc:
        - if !<[spawnerLoc].world.flag[dd_area].contains[<[spawnLoc]>]>:
            - define spawningLocs:<-:<[spawnLoc]>

    #Exclude points that are too close to any player (don't spawn on top of them)
    - if !<[randomOffsetLoc].find_players_within[4].filter_tag[<[filter_value].gamemode.advanced_matches[survival|adventure]>].is_empty>:
        - foreach <[spawningLocs]> as:spawnLoc:
            - if !<[spawnLoc].find_players_within[2].is_empty>:
                - define spawningLocs:<-:<[spawnLoc]>

    #Ignore spawnable points that are within a spawning blocker (specifcally only NULL_TABLE spawn table spawners)
    - define nearbySpawners <[spawnerLoc].find_blocks_flagged[dd_spawner].within[<[spawnerData.spawn_radius]>].exclude[<[spawnerLoc]>]>
    - foreach <[nearbySpawners]> as:spawnerLoc:
        - if <[spawnerLoc].flag[dd_spawner.spawn_table]> == NULL_TABLE:
            - foreach <[spawningLocs]> as:spawnLoc:
                - if <[spawnerLoc].distance[<[spawnLoc]>]> <= <[spawnerLoc].flag[dd_spawner.spawn_radius]>:
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
    - if <[spawnerData.do_spawn_effects].if_null[true]>:
        - run dd_SpawnTables_SpawnerEffects def.loc:<[spawnerLoc]>

    #Track each entity that has spawned
    - foreach <[spawningResults.entities].if_null[<list[]>]> as:entity:
        - flag <[entity]> dd_spawner_location:<[spawnerLoc]>
        - flag <[spawnerLoc]> dd_spawner.entities:->:<[entity]>
        - flag <[spawnerLoc]> dd_spawner.currentlySpawnedPoints:+:<[entity].flag[dd_spawnPoints].if_null[0]>

    #Update currentBank if needed
    - if <[spawnerData.currentBank]> != null:
        - flag <[spawnerLoc]> dd_spawner.currentBank:-:<[spawningResults.spawnedSpawnPoints]>
