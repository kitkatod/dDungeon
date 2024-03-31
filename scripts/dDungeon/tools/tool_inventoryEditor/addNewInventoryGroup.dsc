dd_InventoryEditor_AddNewGroup:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    #Add new entry for the inventory group
    - define newUuid <util.random_uuid>
    - flag <[optionsLoc]> dd_SectionOptions.inventories.<[relativeLoc]>.<[newUuid]>:<map[]>

    - narrate "<blue><italic> *** New Inventory Group Created"

    #Prompt user to add a new category to the new group
    - run dd_InventoryEditor_AddCategoryToGroup_Prompt def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[newUuid]>