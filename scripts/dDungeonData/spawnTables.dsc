dd_SpawnTables:
    debug: false
    type: data
    spawnTables:
        #Spawn Table Name
        generic:
            #Number of entity entries to select when this Spawn Table is rolled
            #(Optional, default is 1)
            _selection_count: 5
            #Name of a Loot Table from dd_LootTables Data Script
            #Also allows "NO_DROPS" in order to prevent any item drops when the entity dies
            #This is a Loot Table default which is set to all entries in the table, unless the entry also has a _loot_table key.
            #(Optional, default is NO_DROPS)
            _loot_table: NO_DROPS
            #Name of an entity. Anything that Denizen treats as a valid entity contructor input can be used here (entity_type, Entity Script, etc)
            #Optional, anything after '#' will be ignored and treated as a comment. This is useful for example, if you want two versions of a "zombie" with different armor. 
            #   ...Might be better to use an Entity Script Container instead in some cases...
            skeleton:
                #Name of a Loot Table from dd_LootTables Data Script
                #(Optional, default is to rely on Spawn Table's _loot_table value)
                _loot_table: NO_DROPS
                #When this entry is selected, number of entities to spawn
                #(Optional, default is 1)
                spawn_count: 1
                #Weight applied to random selection when picking an entity to be spawned
                #An entry with weight=100 is twice as likely to be picked as one with weight=50, and half as likely as one with weight=200
                #(Optional, default is 100)
                weight: 100
                #Number of SpawnPoints each entity spawned is worth as a base
                #This is used to determine the "worth" or "difficulty" of entities spawned
                #See configurations on Spawners and DungeonSettings
                #(Optional, default is 1)
                spawn_points: 3
                #Modifier Tasks are tasks that are passed a reference of the spawned entity, and is run for each entity spawned.
                #Tasks are run in the order listed
                #If only a number is given after the key, it will be treated as the percent chance of running that task (out of 100%)
                #   ...If a map is instead provided, then any key/values will be passed to the task as definitions (for example, "dd_SpawnTables_SetHealth" below will be run with the definitions of healthMin/healthMax passed)
                #(Optional, default is to not run any modifier tasks)
                modifier_tasks:
                    #Name of a Task Script, with an 80% chance of running
                    dd_SpawnTables_RandomArmor: 80
                    #Name of a Task Script, with a 50% chance of running, and will be passed healthMin and healthMax definitions
                    dd_SpawnTables_SetHealth:
                        _chance: 50
                        healthMin: 24
                        healthMax: 34
            zombie:
                spawn_count: 1
                weight: 100
                spawn_points: 3
                modifier_tasks:
                    dd_SpawnTables_RandomArmor: 80
            spider:
                spawn_count: 1
                weight: 40
                spawn_points: 2
            cave_spider:
                spawn_count: 3
                weight: 10
                spawn_points: 2
            creeper:
                spawn_count: 1
                weight: 20
                spawn_points: 5
                modifier_tasks:
                    dd_SpawnTables_chargeCreeper: 20
        blazes:
            _selection_count: 3
            _loot_table: NO_DROPS
            blaze:
                spawn_count: 1
        library_guardians:
            evoker:
                _loot_table: NO_DROPS
                spawn_count: 1
                spawn_points: 5
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 24
                        healthMax: 34
            witch:
                spawn_count: 1
                spawn_points: 3
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 26
                        healthMax: 36

        ambient_stonebrick:
            _selection_count: 3
            _loot_table: NO_DROPS
            pillager:
                weight: 100
                spawn_count: 2
                spawn_points: 1
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 24
                        healthMax: 34
            vindicator:
                weight: 100
                count: 1
                spawn_points: 1
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 24
                        healthMax: 34
            witch:
                weight: 50
                spawn_points: 3
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 26
                        healthMax: 36
            evoker:
                weight: 10
                spawn_points: 5
            ravager:
                weight: 5
                spawn_points: 5

        occupied_illager:
            _selection_count: 2
            _loot_table: NO_DROPS
            pillager:
                weight: 100
                spawn_count: 2
                spawn_points: 1
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 24
                        healthMax: 34
            vindicator:
                weight: 100
                count: 2
                spawn_points: 1
                modifier_tasks:
                    dd_SpawnTables_SetHealth:
                        healthMin: 24
                        healthMax: 34

        arena_fighter_side_a:
            _selection_count: 1
            zombie:
                spawn_count: 1
                modifier_tasks:
                    dd_SpawnTables_RandomArmor:
                        allowedMaterials:
                        - leather
                    dd_SpawnTables_SetColorableEquipmentColor:
                        color: red
                    dd_SpawnTables_SetShieldDesign:
                        base_color: black
                        patterns:
                        - RED/STRIPE_BOTTOM
                        - RED/STRIPE_TOP
                        - WHITE/CREEPER
                    dd_SpawnTables_EnchantEquipment:
                        enchantment_level: 3|4
                        enchantment_count: 1
                        allowed_enchantments:
                        - knockback
                        - sharpness
                        - protection
                        - projectile_protection
                    dd_SpawnTables_ConvertToSentinel:
                        npcId: 9

        arena_fighter_side_b:
            _selection_count: 1
            zombie:
                spawn_count: 1
                modifier_tasks:
                    dd_SpawnTables_RandomArmor:
                        allowedMaterials:
                        - leather
                    dd_SpawnTables_SetColorableEquipmentColor:
                        color: blue
                    dd_SpawnTables_SetShieldDesign:
                        base_color: black
                        patterns:
                        - BLUE/STRIPE_BOTTOM
                        - BLUE/STRIPE_TOP
                        - WHITE/SKULL
                    dd_SpawnTables_EnchantEquipment:
                        enchantment_level: 3|4
                        enchantment_count: 1
                        allowed_enchantments:
                        - knockback
                        - sharpness
                        - protection
                        - projectile_protection
                    dd_SpawnTables_ConvertToSentinel:
                        npcId: 10


