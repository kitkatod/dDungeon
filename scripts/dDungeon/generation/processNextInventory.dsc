dd_ProcessNextInventory:
    debug: false
    type: task
    definitions: world
    script:
    #Get next queued inventory
    - define queueRecord <[world].flag[dd_inventory_queue].first>
    - flag <[world]> dd_inventory_queue:<-:<[queueRecord]>

    - define invLoc <[queueRecord.location]>
    - define invOptions <[queueRecord.options]>
    - define sectionOptions <[queueRecord.sectionOptions]>

    #Ensure chunk is loaded
    - if !<[invLoc].chunk.is_loaded>:
        - chunkload <[invLoc].chunk> duration:5s

    #Make sure location has an inventory. If not, skip and report the error
    - if !<[invLoc].has_inventory>:
        - debug ERROR "(dDungeon) A Loot Table is configured for a block that doesn't have an Inventory. Section:/dDungeon/<[sectionOptions.category]>/<[sectionOptions.type]>/<[sectionOptions.name]>"
        - stop

    #List to hold what categories will be processed into this inventory
    - define invCategories <list[]>

    #Select a category for each inventory group
    - foreach <[invOptions]> key:invGroupId as:invGroupSettings:
        #Get a sum of chances for all categories in the group
        #For each category add an entry to invGroupCategories with a target chance. This will be used to make a weighted(optional) random selection.
        - define invGroupChanceTotal 0
        #List of category entries with target chance
        - define invGroupCategories <list[]>
        - foreach <[invGroupSettings]> key:lootCategory as:chanceValue:
            - define invGroupChanceTotal:+:<[chanceValue]>
            - define invGroupCategories:->:<map[category=<[lootCategory]>;target_chance=<[invGroupChanceTotal]>]>

        #If chance sum is under 100, add a "nothing selected" category to make the total 100
        - if <[invGroupChanceTotal]> < 100:
            - define invGroupCategories:->:<map[category=_nothing;target_chance=100]>
            - define invGroupChanceTotal 100

        #Select a category
        - define selectionVal <util.random.int[1].to[<[invGroupChanceTotal]>]>
        - foreach <[invGroupCategories]> as:cat:
            #If the selected value is below the target chance of the category then we have a winner
            - if <[cat.target_chance]> >= <[selectionVal]>:
                #Only add the category if it isn't our "nothing selected" category
                - if <[cat.category]> != _nothing:
                    #Check if the loot table is "special" for this dungeon
                    #If it's not, just process it right now. If it is then save it to be processed later
                    - if <[world].flag[dd_DungeonSettings.special_loot_tables].contains[<[cat.category]>].if_null[false]>:
                        - flag <[world]> dd_specialLootTables.<[cat.category]>:->:<[invLoc]>
                    - else:
                        - define invCategories:->:<[cat.category]>
                - foreach stop

    #Confirm each LootTable exists
    - foreach <[invCategories]> as:lootTableName:
        - if !<[lootTableName].proc[dd_LootTables_Exists]>:
            - define invCategories:<-:<[lootTableName]>
            - debug ERROR "(dDungeon) Loot Table not found. LootTable:<[lootTableName]> Section:/dDungeon/<[sectionOptions.category]>/<[sectionOptions.type]>/<[sectionOptions.name]>"

    #Roll all categories and place items into the inventory
    - ~run dd_rollLootTable_Inventory def.inventory:<[invLoc].inventory> def.categories:<[invCategories]>








##Example inv settings
##First key is an "inventory group" guid. One category is expected to be selected per group.
##Sub keys are each category in the group, with chance of picking that category as the value.
##If total of all categories in a group is under 100, have a chance of picking nothing for the group
# b6509653-5f20-4838-b4f5-6beb3c73d323:
#     storeroom: '30'
#     categorytwo: '30'




##Example loot table settings
# lootTables:
#         food:
#             _selection_count: 1
#             cod#commentgoeshere:
#                 weight: 1
#                 quantity: 1|15
#                 max_selection_count: -1