dd_SpawnTables_Events:
    debug: false
    type: world
    events:
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

        # Track players that have damaged spawned entities from any given Dungeon Spawner
        on entity_flagged:dd_spawner_location damaged by player in:world_flagged:dd_DungeonSettings:
        - define spawnerLoc <context.entity.flag[dd_spawner_location]>
        # If player isn't already in the list of assisting players then add them
        - if !<[spawnerLoc].flag[dd_spawner.assisting_players].if_null[<list[]>].contains[<context.damager>]>:
            - flag <[spawnerLoc]> dd_spawner.assisting_players:->:<context.damager>