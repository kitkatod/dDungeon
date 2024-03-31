dd_PathwayEditor_AddPath:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define forward <player.location.direction.vector.round.with_y[0].proc[dd_LocationWithoutWorld]>
    - define back <[forward].mul[-1].round>
    - define left <player.location.direction.vector.round.rotate_around_y[<element[90].to_radians>].round>
    - define right <[left].mul[-1].round>
    - define up <location[0,1,0]>
    - define down <location[0,-1,0]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - clickable dd_PathwayEditor_AddPathInDirection def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.direction:<[forward]> usages:1 for:<player> until:1m save:clickForward
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickForward].id>
    - clickable dd_PathwayEditor_AddPathInDirection def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.direction:<[back]> usages:1 for:<player> until:1m save:clickBack
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickBack].id>
    - clickable dd_PathwayEditor_AddPathInDirection def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.direction:<[left]> usages:1 for:<player> until:1m save:clickLeft
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickLeft].id>
    - clickable dd_PathwayEditor_AddPathInDirection def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.direction:<[right]> usages:1 for:<player> until:1m save:clickRight
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickRight].id>
    - clickable dd_PathwayEditor_AddPathInDirection def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.direction:<[up]> usages:1 for:<player> until:1m save:clickUp
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickUp].id>
    - clickable dd_PathwayEditor_AddPathInDirection def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.direction:<[down]> usages:1 for:<player> until:1m save:clickDown
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDown].id>

    - narrate "<blue> *** Click on the direction from the target block the pathway should extend, based on the direction you're facing<n>"
    - narrate "<gold>         [<element[FORWARD].on_click[<entry[clickForward].command>]>]                [<element[UP].on_click[<entry[clickUp].command>]>]"
    - narrate "<gold>[<element[LEFT].on_click[<entry[clickLeft].command>]>]               [<element[RIGHT].on_click[<entry[clickRight].command>]>]"
    - narrate "<gold>           [<element[BACK].on_click[<entry[clickBack].command>]>]                 [<element[DOWN].on_click[<entry[clickDown].command>]>]"

dd_PathwayEditor_AddPathInDirection:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|direction|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.direction:<[direction]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.possible_connections:<map[]>
    - narrate "<blue> *** New Pathway Added"
    - wait 15t
    - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>
