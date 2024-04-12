dd_SchematicEditor_PrintOptionsData:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsBlockData <[optionsLoc].flag[dd_SectionOptions]>
    - ~run dd_NarrateObject def.obj:<[optionsBlockData]> "def.message:Options Block Data"