dd_InventoryEditor_RemoveCategoryFromGroup_Prompt:
    debug: false
    type: task
    definitions: category|groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Confirm removing <reset><yellow><[category]> <blue><italic> from group"

    - clickable dd_InventoryEditor_RemoveCategoryFromGroup def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.category:<[category]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickConfirm
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickConfirm].id>
    - clickable dd_InventoryEditor_CategoryGroupMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickCancel
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>

    - narrate "<blue> * <red>[<element[CONFIRM].on_click[<entry[clickConfirm].command>]>]<blue> | <yellow>[<element[CANCEL].on_click[<entry[clickCancel].command>]>]"

dd_InventoryEditor_RemoveCategoryFromGroup:
    debug: false
    type: task
    definitions: category|groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[optionsLoc]> dd_SectionOptions.inventories.<[relativeLoc]>.<[groupId]>.<[category]>:!
    - narrate "<blue><italic> *** <[category]> removed from group"
    - wait 1s
    - run dd_InventoryEditor_CategoryGroupMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]>