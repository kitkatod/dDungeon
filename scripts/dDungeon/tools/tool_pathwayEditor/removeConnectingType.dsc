dd_PathwayEditor_PromptRemoveConnectingType_Confirm:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|type|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - clickable dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickCancel
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
    - clickable dd_PathwayEditor_RemoveConnectingType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickConfirm
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickConfirm].id>
    - narrate "<blue> Confirm removing Connection Type <red>[<[type]>] <blue>from Pathway: <gold>[<element[CANCEL].on_click[<entry[clickCancel].command>]>] <blue>| <red>[<element[CONFIRM REMOVE].on_click[<entry[clickConfirm].command>]>]"

dd_PathwayEditor_RemoveConnectingType:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|type|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.possible_connections.<[type]>:!
    - narrate "<blue><italic> *** Removed Connection Type <red>[<[type]>] <blue>from Pathway"
    - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>