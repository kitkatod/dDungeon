dd_SchematicEditor_SetType:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId|returnToMainMenu
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - define optionsBlockData <[optionsLoc].flag[dd_SectionOptions]>
    - define category <[optionsBlockData.category].if_null[Stone_Sewer]>
    - narrate "<blue><italic> *** Click the section type for this schematic"
    - define typeList <util.list_files[schematics/dDungeon/<[category]>/]>
    - foreach <[typeList]> as:type:
        - clickable dd_SchematicCreator_setProperty def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.settingName:type def.value:<[type]> def.returnToMainMenu:<[returnToMainMenu].if_null[false]> for:<player> until:1m save:clickable
        - narrate "<blue><italic> *** <reset><gold>[<element[<[type]>].on_click[<entry[clickable].command>]>]"
