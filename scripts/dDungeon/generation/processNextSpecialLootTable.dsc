dd_ProcessNextSpecialLootTable:
    debug: false
    type: task
    definitions: world
    script:
    #Get next special loot table category, with list of locations to apply it
    - define cat <[world].flag[dd_specialLootTables].keys.first>
    - define invLocs <[world].flag[dd_specialLootTables.<[cat]>]>
    - flag <[world]> dd_specialLootTables.<[cat]>:!

    #Get items based on categories
    - define lootItems <[cat].proc[dd_RollLootTable_Category].if_null[<list[]>]>

    #Try to put each item into a only chest once
    #If the item doesn't fit in any chest, just ignore it
    - foreach <[lootItems]> as:item:
        #Get copy of locations, randomize order
        - define possibleInvs <[invLocs].random[<[invLocs].size>]>

        #Check each possible chest we could put the item in
        - foreach <[possibleInvs]> as:invLoc:
            #Ensure chunk is loaded
            - if !<[invLoc].chunk.is_loaded>:
                - chunkload <[invLoc].chunk> duration:10s
            #Check if we can put the item in the inventory
            - if <[invLoc].has_inventory> && <[invLoc].inventory.empty_slots> > 0:
                #If we can fit it, give the item and stop checking for locations
                - give <[item]> quantity:<[item].quantity> to:<[invLoc].inventory> slot:<[invLoc].inventory.find_empty_slots.random>
                - foreach stop




dd_ProcessDungeonGlobalLoot:
    debug: false
    type: task
    definitions: world
    script:
    #Get items based on categories
    - define lootItems <list[]>
    - foreach <[world].flag[dd_DungeonSettings.global_loot].if_null[<list[]>]> as:cat:
        - foreach <[cat].proc[dd_RollLootTable_Category].if_null[<list[]>]> as:item:
            - define lootItems:->:<[item]>

    #Get list of all inventories we can put items into
    - define invLocs <[world].flag[dd_all_inventories]>

    #Try to put each item into a only chest once
    #If the item doesn't fit in any chest, just ignore it
    - foreach <[lootItems]> as:item:
        #Get copy of locations, randomize order
        - define possibleInvs <[invLocs].random[<[invLocs].size>]>

        #Check each possible chest we could put the item in
        - foreach <[possibleInvs]> as:invLoc:
            #Ensure chunk is loaded
            - if !<[invLoc].chunk.is_loaded>:
                - chunkload <[invLoc].chunk> duration:10s
            #Check if we can put the item in the inventory
            - if <[invLoc].has_inventory> && <[invLoc].inventory.empty_slots> > 0:
                #If we can fit it, give the item and stop checking for locations
                - give <[item]> quantity:<[item].quantity> to:<[invLoc].inventory> slot:<[invLoc].inventory.find_empty_slots.random>
                - foreach stop