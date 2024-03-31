dd_PathwayEditor_EditResetHallwayCount:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId|value
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.resetHallwayCount:<[value]>
    - narrate "<n><blue><italic> *** Reset Hallway Count value updated"
    - wait 10t
    - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>
