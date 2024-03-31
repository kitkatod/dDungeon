dd_InventoryEditor_AddCategoryToGroup_Prompt:
    debug: false
    type: task
    definitions: groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    #Get list of current categories
    - define categories <[optionsData.inventories.<[relativeLoc]>.<[groupId]>].keys>
    #Get list of configured loot table categories
    - define lootTableCategories <script[dd_LootTables].data_key[lootTables].keys.alphabetical>

    - foreach <[lootTableCategories]> as:lootTableCat:
        #Skip the category if it is already listed in the group
        - if <[categories].contains[<[lootTableCat]>]>:
            - foreach next
        - clickable dd_InventoryEditor_AddCategoryToGroup def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.category:<[lootTableCat]> for:<player> usages:1 until:5m save:clickCat
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCat].id>
        - narrate "<blue> * <gold>[<[lootTableCat].on_click[<entry[clickCat].command>]>]"


dd_InventoryEditor_AddCategoryToGroup:
    debug: false
    type: task
    definitions: category|groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    #Add the category, set a default value (chance)
    - flag <[optionsLoc]> dd_SectionOptions.inventories.<[relativeLoc]>.<[groupId]>.<[category]>:50

    #Prompt user for a chance value
    - narrate "<blue><italic> *** Category added: <[category]>"
    - run dd_InventoryEditor_ModifyCategoryChance def.category:<[category]> def.groupId:<[groupId]> def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>