dd_SpawnTables_AmbientSpawning:
    debug: false
    type: task
    definitions: world
    script:
    - if !<[world].has_flag[dd_DungeonSettings]>:
        - stop
    - define dungeonSettings <[world].flag[dd_DungeonSettings]>

    - define players <[world].players>
    - foreach <[players]> as:player:
        #Check if we've spawned for the player recently
        - if <[player].has_flag[dd_SpawnTables_spawnedRecently]>:
            - foreach next

        #Only spawn for players in target gamemodes
        - if <[player].gamemode> != survival:
            - foreach next

        #Randomly just don't spawn anything
        - if <util.random_chance[20]>:
            - foreach next

        #Skip player if they are currently in a chunk that has met the spawn threshold
        - if <player.location.chunk.flag[dd_spawnPointsUsed].if_null[0]> >= <[dungeonSettings.ambient_spawn_points_per_grid_section_max].if_null[50]>:
            - foreach next

        #Get SpawnPoint max for the dungeon the player is in
        - define spawnPointsMax <[dungeonSettings.ambient_spawn_points_per_player].if_null[10]>

        #Modify SpawnPoint max based on the number of players nearby
        - define spawnPointsMax:+:<[player].location.find_players_within[10].size.sub[1].mul[0.5]>

        #Check current mob points total around player
        - define nearbySpawnPoints <[player].location.find.living_entities.within[15].filter_tag[<[filter_value].has_flag[dd_spawnPoints].if_null[false]>].parse_tag[<[parse_value].flag[dd_spawnPoints]>].if_null[0].sum>

        #Skip spawning for player if count is high enough
        - define allowedSpawnPoints <[spawnPointsMax].sub[<[nearbySpawnPoints]>]>
        - if <[allowedSpawnPoints]> <= 0:
            - foreach next

        #Find nearby spawnable points
        - define spawningLocs <[player].location.find_spawnable_blocks_within[15]>

        #Ignore spawnable points that are within a spawning blocker, or nearby a spawner preventing normal dungeon spawning
        - define nearbySpawners <[player].location.find_blocks_flagged[dd_spawner].within[30]>
        - foreach <[nearbySpawners]> as:spawnerLoc:
            - if <[spawnerLoc].flag[dd_spawner.prevent_dungeon_spawning_nearby]> || <[spawnerLoc].flag[dd_spawner.spawn_table]> == NULL_TABLE:
                #Remove spawnable points that are within Spawn Radius
                - foreach <[spawningLocs]> as:spawnLoc:
                    - if <[spawnerLoc].distance[<[spawnLoc]>]> <= <[spawnerLoc].flag[dd_spawner.spawn_radius]>:
                        - define spawningLocs:<-:<[spawnLoc]>

        #Exclude points that are too close to any player (don't spawn on top of them)
        #, or outside dungeon area
        - foreach <[spawningLocs]> as:spawnLoc:
            - if !<[spawnLoc].find_players_within[10].is_empty>:
                - define spawningLocs:<-:<[spawnLoc]>
            - if !<[world].flag[dd_area].contains[<[spawnLoc]>]>:
                - define spawningLocs:<-:<[spawnLoc]>
            - if <[spawnLoc].light> > 0:
                - define spawningLocs:<-:<[spawnLoc]>
            #Skip if grid section has met the spawn threshold
            - if <[spawnLoc].proc[dc_SpawnTables_AmbientSpawnLocationGrid].flag[dd_spawnPointsUsed].if_null[0]> >= <[dungeonSettings.ambient_spawn_points_per_grid_section_max].if_null[50]>:
                - define spawningLocs:<-:<[spawnLoc]>


        #Skip player if there aren't valid points
        - if <[spawningLocs].is_empty>:
            - foreach next

        #Do the spawn!
        # - announce "<gold><bold> *** Spawned mobs for <italic><underline><[player].name>"
        - flag <[player]> dd_SpawnTables_spawnedRecently:true expire:<[dungeonSettings.ambient_spawn_player_delay_period].if_null[10s]>
        - ~run dd_rollSpawnTable def.loc:<[spawningLocs].random> def.spawnTable:<[dungeonSettings.ambient_spawn_table].if_null[generic]> def.targetSpawnPoints:<[allowedSpawnPoints]> save:spawnRun

        #Bump up the grid section's spawn points used flag for each entity spawned, and how many points they're worth
        - define spawningResults <entry[spawnRun].created_queue.determination.first>
        - foreach <[spawningResults.entities]> as:entity:
            - flag <[entity].location.proc[dc_SpawnTables_AmbientSpawnLocationGrid]> dd_spawnPointsUsed:+:<[entity].flag[dd_spawnPoints]>

        # - define spawningResults <entry[spawnRun].created_queue.determination>