dd_InventoryEditor_AddNewInventory:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[optionsLoc]> dd_SectionOptions.inventories.<[relativeLoc]>:<map[]>
    - narrate "<blue><italic> *** New Inventory Created"
    - wait 10t
    - run dd_InventoryEditor_AddNewGroup def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>