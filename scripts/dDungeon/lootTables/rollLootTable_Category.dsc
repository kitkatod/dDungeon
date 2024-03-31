dd_RollLootTable_Category:
    debug: false
    type: procedure
    definitions: lootTableCategory
    script:
    #Verify LootTable exists
    - if !<[lootTableCategory].proc[dd_LootTables_Exists]>:
        - debug ERROR "Loot Table not found when generating dDungeon loot. LootTable Key: <[lootTableCategory]>"
        - stop

    #Get LootTable data
    - define lootTable <[lootTableCategory].proc[dd_LootTables_GetData]>

    #Process _import_from values
    - foreach <[lootTable._import_from].if_null[<list[]>]> as:importTable:
        - if !<[lootTable].keys.contains[<[importTable]>]>:
            - define importTableData <script[dd_LootTables].data_key[lootTables.<[importTable]>].if_null[null]>
            - if <[importTableData]> == null:
                - debug ERROR "Loot Table not found when importing LootTable for dDungeon loot. Missing LootTable Key: <[importTable]>"
                - foreach next
            - foreach <[importTableData]> as:importItem key:importKey:
                #Skip keys with an underscore prefix
                - if <[importKey].starts_with[_]>:
                    - foreach next
                #Import the item
                - define lootTable.<[importKey]> <[importItem]>

    #Determine number of items to select
    - define selectionCount <[lootTable._selectionCount].if_null[1]>
    - if <[selectionCount].escaped.contains_all_text[&pipe]>:
        - define selectionCount <[selectionCount].proc[dd_TrangularDistroRandomInt]>

    #Define default weight for table if applicable
    - define weight <[lootTable._weight].if_null[100]>

    #Pick items from category
    - define returnItems <list[]>
    - repeat <[selectionCount]>:
        #Get a running total for each item, save to list with the current running total
        - define selectionTotalWeight 0
        - define lootTableItems <list[]>
        - foreach <[lootTable]> key:itemKey as:itemEntry:
            #Skip loot table keys that are loot table settings, not loot entries
            - if <[itemKey].starts_with[_]>:
                - foreach next
            - define selectionTotalWeight:+:<[itemEntry.weight].if_null[<[weight]>]>
            - define lootTableItems:->:<map[item_key=<[itemKey]>;target_weight=<[selectionTotalWeight]>]>

        - define selectedValue <util.random.decimal[0.1].to[<[selectionTotalWeight]>]>
        - foreach <[lootTableItems]> as:itemEntry:
            #If the selected value is below the target chance of the item then we have a winner!
            - if <[itemEntry.target_weight]> >= <[selectedValue]>:
                - define itemData <[lootTable.<[itemEntry.item_key]>]>
                #Get item name (remove any comments/details at end of name)
                - define itemName <[itemEntry.item_key].before_last[#]>
                #Get quantity to add
                - if <[itemData].object_type> == map:
                    - define quantity <[itemData.quantity].if_null[1]>
                - else:
                    - define quantity <[itemData]>
                - if <[quantity].escaped.contains_all_text[&pipe]>:
                    - define quantity <[quantity].proc[dd_TrangularDistroRandomInt]>

                #Get number of stacks the item should be split up into
                - define allowSplitStack <[itemData.allow_split_stack].if_null[<[lootTable._allow_split_stack].if_null[true]>]>

                #Get item from the input (mainly needed in case we're passed a procedure script)
                - define item <[itemName].proc[dd_LootTables_ItemFromInput].context[<[itemData.item_proc_args].if_null[null]>]>

                #If still a valid item, pass item through modifier procedures if defined
                - if <[item].object_type.if_null[null]> == item:
                    - foreach <[itemData.modifier_procs].if_null[<map[]>]> as:procData key:procName:
                        - define item <[item].proc[<[procName]>].context[<[procData]>]>

                #If we have an item created now, run normal modifications on the item as needed
                - if <[item].object_type.if_null[null]> == item:
                    #Flag item based on loot table
                    - foreach <[lootTable._flags].if_null[<map[]>]> as:flagValue key:flagName:
                        - define item <[item].with_flag[<[flagName]>:<[flagValue]>]>

                    #Flag item based on item entry
                    - foreach <[itemData._flags].if_null[<map[]>]> as:flagValue key:flagName:
                        - define item <[item].with_flag[<[flagName]>:<[flagValue]>]>

                    #Randomize durability if allowed
                    - if <[itemData.randomize_durability].if_null[true]>:
                        - define item <[item].proc[dd_LootTables_RandomizeDurability]>

                    #Item doesn't support stacking. Pick the number of single items
                    - if <[item].material.max_stack_size> == 1:
                        - repeat <[quantity]>:
                            - define returnItems:->:<[item]>
                    #Loot table disallows splitting stacks. Place max stack sizes
                    - else if !<[allowSplitStack]>:
                        - while <[quantity]> > 0:
                            - define count <[quantity]>
                            - if <[count]> > <[item].max_stack>:
                                - define count <[quantity]>
                            - define quantity:-:<[count]>
                            - adjust def:item quantity:<[count]>
                            - define returnItems:->:<[item]>
                    #Config allows stack splitting, and item can be stacked
                    #Randomly split up the item quantity a couple times to add some randomness
                    - else:
                        - define minCount <[quantity].mul[0.1].round_up>

                        #maxCount is based on either quantity or max_stack, whichever is smaller
                        - if <[quantity]> > <[item].max_stack>:
                            - define maxCount <[item].max_stack.mul[0.55].round>
                        - else:
                            - define maxCount <[quantity].mul[0.55].round>

                        - while <[quantity]> > 0:
                            - define count <proc[dd_TrangularDistroRandomInt].context[<[minCount]>|<[maxCount]>]>
                            - if <[count]> > <[quantity]>:
                                - define count <[quantity]>
                            - define quantity:-:<[count]>
                            - adjust def:item quantity:<[count]>
                            - define returnItems:->:<[item]>

                #Decrease maxSelectionCount for the item key
                - define lootTable.<[itemEntry.item_key]>.max_selection_count:--
                #If decreasing makes the item key's maxSelectionCount equal zero, remove the entire key
                #(Less than 0 is okay. -1 indicates no limit is set, so we can keep going.)
                - if <[lootTable.<[itemEntry.item_key]>.max_selection_count].if_null[-1]> == 0:
                    - define lootTable.<[itemEntry.item_key]>:!

                #Stop this run of selecting an item
                - foreach stop

    - determine <[returnItems]>