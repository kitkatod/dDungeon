dd_SchematicEditor_ShowBoundary:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId|returnToMainMenu
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsBlockData <[optionsLoc].flag[dd_SectionOptions]>
    - define pos1 <[optionsLoc].add[<[optionsBlockData.pos1]>]>
    - define pos2 <[optionsLoc].add[<[optionsBlockData.pos2]>]>
    - define cuboid <[pos1].to_cuboid[<[pos2]>]>
    - define cuboid <[cuboid].expand_one_side[1]>

    - if <[returnToMainMenu].if_null[false]>:
        - narrate "<n><blue><italic> *** Showing Section Boundary"
        - wait 10t
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>

    - run dd_OutlineArea def.area:<[cuboid]> def.color:red def.duration:30s
