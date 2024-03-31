dd_InventoryEditor_ModifyCategoryChance:
    debug: false
    type: task
    definitions: category|groupId|relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Type in chat a new chance value"
    - narrate "<blue><italic>     (Typically the total of all chacne values in the group should be 100 or less)"

    - define map <map[]>
    - define map.category <[category]>
    - define map.groupId <[groupId]>
    - define map.relativeLoc <[relativeLoc]>
    - define map.optionsLoc <[optionsLoc]>
    - flag <player> dd_InventoryEditor_ModifyCategoryChance:<[map]> expire:5m


dd_InventoryEditor_ModifyCategoryChance_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_InventoryEditor_ModifyCategoryChance:
        - determine cancelled passively
        - define value <context.message>
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Category Chance must be a decimal."
            - stop

        #Get settings saved to player
        - define map <player.flag[dd_InventoryEditor_ModifyCategoryChance]>
        #Update the section config
        - flag <[map.optionsLoc]> dd_SectionOptions.inventories.<[map.relativeLoc]>.<[map.groupId]>.<[map.category]>:<[value]>

        - flag <player> dd_InventoryEditor_ModifyCategoryChance:!
        - narrate "<blue><italic> *** Category Chance Set: <[value]>"

        - run dd_InventoryEditor_CategoryGroupMenu def.groupId:<[map.groupId]> def.relativeLoc:<[map.relativeLoc]> def.optionsLoc:<[map.optionsLoc]>