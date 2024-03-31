dd_InventoryEditor_CopySettings:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <player> dd_InventoryEditor_CopiedSettings:<[optionsLoc].flag[dd_SectionOptions.inventories.<[relativeLoc]>]>
    - narrate "<blue><italic> *** Inventory Settings Copied"
    - wait 1s
    - run dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>