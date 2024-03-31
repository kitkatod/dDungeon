dd_InventoryEditor_RemoveInventoryGroup_Prompt:
    debug: false
    type: task
    definitions: groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Confirm removing inventory group"

    - clickable dd_InventoryEditor_RemoveInventoryGroup def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickConfirm
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickConfirm].id>
    - clickable dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickCancel
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>

    - narrate "<blue> * <red>[<element[CONFIRM].on_click[<entry[clickConfirm].command>]>]<blue> | <yellow>[<element[CANCEL].on_click[<entry[clickCancel].command>]>]"

dd_InventoryEditor_RemoveInventoryGroup:
    debug: false
    type: task
    definitions: groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[optionsLoc]> dd_SectionOptions.inventories.<[relativeLoc]>.<[groupId]>:!
    - narrate "<blue><italic> *** Inventory Group Removed"
    - wait 1s
    - run dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>