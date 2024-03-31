dd_DungeonEntranceEditor_DeleteEntrance:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - clickable dd_DungeonEntranceEditor_DeleteEntrance_Confirm def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickConfirm
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickConfirm].id>
    - clickable dd_DungeonEntranceEditor_MainMenu def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickCancel
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>

    - narrate "<blue> *** Confirm Deleting Entrance: <gold><underline>[<element[CANCEL].on_click[<entry[clickCancel].command>]>]<reset> | <red>[<element[DELETE].on_click[<entry[clickConfirm].command>]>]"



dd_DungeonEntranceEditor_DeleteEntrance_Confirm:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[loc]> dd_entrance:!
    - narrate "<blue> *** Entrance deleted"