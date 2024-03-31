dd_InventoryEditor_PasteSettings:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define settings <player.flag[dd_InventoryEditor_CopiedSettings]>
    - flag <[optionsLoc]> dd_SectionOptions.inventories.<[relativeLoc]>:<[settings]>
    - narrate "<blue><italic> *** Inventory Settings Pasted"
    - wait 1s
    - run dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>