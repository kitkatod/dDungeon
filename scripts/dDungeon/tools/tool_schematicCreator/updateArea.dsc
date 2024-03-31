dd_SchematicEditor_UpdateAreaFromWorldEdit:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - if <player.we_selection.object_type.if_null[empty]> != Cuboid:
        - narrate "<red><italic> *** Set a selection using WorldEdit before trying to update section area"
        - wait 10t
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>
        - stop

    - define selectionCuboid <player.we_selection>
    - define relativePos1 <[selectionCuboid].min.sub[<[optionsLoc]>]>
    - define relativePos2 <[selectionCuboid].max.sub[<[optionsLoc]>]>
    - flag <[optionsLoc]> dd_SectionOptions.pos1:<[relativePos1].proc[dd_LocationWithoutWorld]>
    - flag <[optionsLoc]> dd_SectionOptions.pos2:<[relativePos2].proc[dd_LocationWithoutWorld]>
    - narrate "<blue><italic> *** Schematic Area Set"

    - wait 10t
    - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>
