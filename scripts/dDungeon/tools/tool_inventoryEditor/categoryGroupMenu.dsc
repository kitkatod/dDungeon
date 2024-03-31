dd_InventoryEditor_CategoryGroupMenu:
    debug: false
    type: task
    data:
        hint_EditChance: Modify the chance of this category being selected<n>If the total of all chances in the group is less than 100,<n>there will be a chance no category is selected.
    definitions: groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    #Get list of categories
    - define categories <[optionsData.inventories.<[relativeLoc]>.<[groupId]>]>

    #Show menu
    - narrate "<n><blue><italic> *** Click below to make changes to this Inventory Group."
    - narrate "<blue><italic>     Note - Only one category is selected from an Inventory Group."
    - narrate "<blue><italic>     If the chance of all categories in the group is below 100, a category might not be picked at all."

    - clickable dd_InventoryEditor_AddCategoryToGroup_Prompt def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickAddNew
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAddNew].id>
    - narrate "<blue> * <green>[<element[ADD NEW CATEGORY].on_click[<entry[clickAddNew].command>]>]"

    - define nothingChance 100

    - foreach <[categories]> as:chance key:category:
        - define nothingChance:-:<[chance]>

        - clickable dd_InventoryEditor_ModifyCategoryChance def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.category:<[category]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickEdit
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickEdit].id>
        - clickable dd_InventoryEditor_RemoveCategoryFromGroup_Prompt def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.category:<[category]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickRemove
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickRemove].id>
        - narrate "<blue> * <[category]> (<[chance]>) <gold>[<element[EDIT CHANCE].on_click[<entry[clickEdit].command>]>] <red>[<element[REMOVE].on_click[<entry[clickRemove].command>]>]"
    - if <[nothingChance]> < 0:
        - define nothingChance 0
    - narrate "<blue> * <italic>NOTHING <reset><blue>(<[nothingChance]>)"

    - clickable dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickBack
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickBack].id>
    - narrate " * <yellow>[<element[BACK].on_click[<entry[clickBack].command>]>]"