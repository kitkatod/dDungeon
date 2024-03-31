dd_PathwayEditor_ToggleAllowIncoming:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define currentSetting <[optionsLoc].flag[dd_SectionOptions.pathways.<[relativeLoc]>.allowIncoming].if_null[true]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.allowIncoming:<[currentSetting].not>

    - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>
