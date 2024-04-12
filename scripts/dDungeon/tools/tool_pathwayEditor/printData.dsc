dd_PathwayEditor_PrintData:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define pathwayData <[optionsLoc].flag[dd_SectionOptions.pathways.<[relativeLoc]>]>
    - run dd_NarrateObject def.obj:<[pathwayData]> "def.message:Pathway Data"