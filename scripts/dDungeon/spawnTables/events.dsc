dd_SpawnTables_Events:
    debug: false
    type: world
    events:
        #Run Ambient spawning and Spawner spawning
        on delta time secondly every:5:
        - ~run dd_SpawnTables_CleanupSpawnerBossbars
        - foreach <server.worlds> as:world:
            - if !<[world].has_flag[dd_DungeonSettings]> || !<[world].flag[dd_allowSpawning].if_null[false]>:
                - foreach next

            - ~run dd_SpawnTables_AmbientSpawning def.world:<[world]>

            #Run spawning on each spawner in the world
            - define spawnerLocs <[world].flag[dd_spawnerLocs]>
            - foreach <[spawnerLocs]> as:spawnerLoc:
                - ~run dd_SpawnTables_RunSpawner def.spawnerLoc:<[spawnerLoc]>

        #Roll Loot Tables for entities
        on entity dies in:world_flagged:dd_DungeonSettings:
        - if !<context.entity.has_flag[dd_lootTable]>:
            - stop

        - define lootTableName <context.entity.flag[dd_lootTable]>
        - choose <[lootTableName]>:
            - case null:
                - stop
            - case NO_DROPS:
                - determine NO_DROPS
            - default:
                - determine <[lootTableName].proc[dd_RollLootTable_Category]>

        #Untrack NPC as it dies
        on npc dies in:world_flagged:dd_npcs:
        - flag <context.entity.location.world> dd_npcs:<-:<context.entity>

        #Update Spawner data for entites killed/despawned if it was spawned by a spawner
        on entity despawns in:world_flagged:dd_DungeonSettings:
        - ratelimit <context.entity> 1t
        - if <context.entity.has_flag[dd_spawner_location]>:
            - define spawnLoc <context.entity.flag[dd_spawner_location]>
            - if <[spawnLoc].chunk.is_loaded> && <[spawnLoc].has_flag[dd_spawner]>:
                - flag <[spawnLoc]> dd_spawner.entities:<-:<context.entity>
                - flag <[spawnLoc]> dd_spawner.currentlySpawnedPoints:-:<context.entity.flag[dd_spawnPoints].if_null[0]>
                - if <[spawnLoc].flag[dd_spawner.bossbar_enabled].if_null[false]>:
                    - run dc_SpawnTables_UpdateSpawnerBossbar def.spawnerLoc:<[spawnLoc]>

        #Track players that have damaged an entity spawned from some kind of Dungeon Spawning
        on entity_flagged:dd_spawn_table damaged by player in:world_flagged:dd_DungeonSettings:
        # If player isn't already in the list of assisting players for the entity then add them
        - if !<context.entity.flag[dd_assisting_players].if_null[<list[]>].contains[<player>]>:
            - flag <context.entity> dd_assisting_players:->:<player>

        #If entity was spawned from a specific spawner, also track assisting players on the spawner itself
        - if <context.entity.has_flag[dd_spawner_location]>:
            - define spawnerLoc <context.entity.flag[dd_spawner_location]>
            # If player isn't already in the list of assisting players for the spawner then add them
            - if !<[spawnerLoc].flag[dd_spawner.assisting_players].if_null[<list[]>].contains[<context.damager>]>:
                - flag <[spawnerLoc]> dd_spawner.assisting_players:->:<context.damager>

        #Fire event that a spawner entity was killed
        on entity_flagged:dd_spawn_table killed by player in:world_flagged:dd_DungeonSettings:
        - define spawnerLoc <context.entity.flag[dd_spawner_location].if_null[null]>

        #Fire event
        - definemap context spawner_location:<[spawnerLoc]> entity:<context.entity> assisting_players:<context.entity.flag[dd_assisting_players].if_null[<list[]>]> spawn_table:<context.entity.flag[dd_spawn_table]>
        - customevent id:dd_dungeon_spawned_entity_killed context:<[context]>