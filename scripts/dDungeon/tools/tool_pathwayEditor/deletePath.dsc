dd_PathwayEditor_DeletePath:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - clickable dd_PathwayEditor_DeletePath_Confirm def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickConfirm
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickConfirm].id>
    - clickable dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickCancel
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>

    - narrate "<blue> *** Confirm Deleting Pathway: <gold><underline>[<element[CANCEL].on_click[<entry[clickCancel].command>]>]<reset> | <red>[<element[DELETE].on_click[<entry[clickConfirm].command>]>]"

dd_PathwayEditor_DeletePath_Confirm:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>:!
    - narrate "<blue> *** Pathway deleted from section"