dd_RollSpawnTable:
    debug: false
    type: task
    definitions: loc|spawnTable|targetSpawnPoints|spawnRadius
    script:
    #Get Spawn Table data
    - define spawnTableData <script[dd_SpawnTables].data_key[spawnTables].get[<[spawnTable]>].if_null[null]>
    - if <[spawnTableData]> == null:
        - stop

    #Fill in default values if needed
    - define targetSpawnPoints <[targetSpawnPoints].if_null[0]>
    - define spawnRadius <[spawnRadius].if_null[3]>
    - define spawnedSpawnPoints 0

    #Determine number of entity entries to select
    - define selectionCount <[spawnTableData._selection_count].if_null[1]>
    - if <[selectionCount].escaped.contains_all_text[&pipe]>:
        - define selectionCount <[selectionCount].proc[dd_TrangularDistroRandomInt]>

    #Prepare return context
    - define return <map[targetSpawnPoints=<[targetSpawnPoints]>]>

    #Get a running total for each item, save to list with the current running total
    #Will be used for doing weighted random selection
    - define selectionTotalWeight 0
    - define spawnTableEntries <list[]>
    - foreach <[spawnTableData]> key:spawnKey as:spawnEntry:
        #Skip loot table keys that are loot table settings, not loot entries
        - if <[spawnKey].starts_with[_]>:
            - foreach next
        - define selectionTotalWeight:+:<[spawnEntry.weight].if_null[100]>
        - define spawnTableEntries:->:<map[item_key=<[spawnKey]>;target_weight=<[selectionTotalWeight]>]>

    #Get list of entities selected from Spawn Table
    - define spawnTableEntities <list[]>
    - repeat <[selectionCount]>:
        #Stop processing if we've reached the spawn point target
        - if <[spawnedSpawnPoints]> >= <[targetSpawnPoints]>:
            - repeat stop

        - define selectedValue <util.random.int[1].to[<[selectionTotalWeight]>]>
        - foreach <[spawnTableEntries]> as:spawnEntry:
            #Stop processing if we've reached the spawn point target
            - if <[spawnedSpawnPoints]> >= <[targetSpawnPoints]>:
                - foreach stop

            #If the selected value is below the target chance of the item then we have a winner!
            - if <[spawnEntry.target_weight]> >= <[selectedValue]>:
                - define spawnData <[spawnTableData.<[spawnEntry.item_key]>]>
                #Get item name (remove any comments/details at end of name)
                - define entityName <[spawnEntry.item_key].before_last[#]>
                #Get count to spawn
                - if <[spawnData].object_type> == map:
                    - define spawnCount <[spawnData.spawn_count].if_null[1]>
                - else:
                    - define spawnCount <[spawnData]>
                - if <[spawnCount].escaped.contains_all_text[&pipe]>:
                    - define spawnCount <[spawnCount].proc[dd_TrangularDistroRandomInt]>

                #Get number of spawn points this mob is worth
                - define spawnPoints <[spawnData.spawn_points].if_null[1]>

                - repeat <[spawnCount]>:
                    #Stop processing if we've reached the spawn point target
                    - if <[spawnedSpawnPoints]> >= <[targetSpawnPoints]>:
                        - repeat stop

                    - define cLoc <[loc].proc[dd_SpawnTables_randomSpawnableLoc].context[<[spawnRadius]>]>
                    - spawn <[entityName]> <[cLoc]> save:entity
                    - define entity <entry[entity].spawned_entity>
                    - adjust <[entity]> persistent:true
                    - flag <[entity]> dd_spawnPoints:<[spawnPoints]>
                    - flag <[entity]> dd_spawn_table:<[spawnTable]>

                    - define lootTableName <[spawnData._loot_table].if_null[null]>
                    - if <[lootTableName]> == null:
                        - define lootTableName <[spawnTableData._loot_table].if_null[null]>
                    - if <[lootTableName]> != null:
                        - flag <[entity]> dd_lootTable:<[lootTableName]>

                    - foreach <[spawnData.modifier_tasks].keys||<list[]>> as:modifierTaskKey:
                        - define modifierTaskData <[spawnData.modifier_tasks.<[modifierTaskKey]>]>

                        - if <[modifierTaskData].object_type> == map:
                            - define chance <[modifierTaskData._chance].if_null[100]>
                            - define taskDefs <[modifierTaskData]>
                            - define taskDefs._chance !
                            - define taskDefs.entity <[entity]>
                        - else:
                            - define chance <[modifierTaskData]>
                            - define taskDefs <map[entity=<[entity]>]>

                        #Roll chance, run task if needed
                        - if <util.random_chance[<[chance]>]>:
                            #If there are any comments at the end of the task, remove them
                            - define modifierTaskKey <[modifierTaskKey].before_last[#]>

                            #Run the task
                            - ~run <[modifierTaskKey]> defmap:<[taskDefs]> save:taskResult
                            - foreach <entry[taskResult].created_queue.determination.if_null[<list[]>]> as:taskResultEntry:
                                - if <[taskResultEntry].starts_with[entity:]>:
                                    - define entity <[taskResultEntry].after[entity:].as[entity]>

                    #After spawning and modifiers are done running, decrease target spawn points by mob's current mob point value
                    - define spawnedSpawnPoints:+:<[entity].flag[dd_spawnPoints].if_null[1]>
                    - define return.entities:->:<[entity]>


                #Skip running foreach further once something is selected
                - foreach stop

    - run dd_SpawnTables_SpawnEffects def.loc:<[loc]>
    - define return.spawnedSpawnPoints <[spawnedSpawnPoints]>
    - determine <[return]>