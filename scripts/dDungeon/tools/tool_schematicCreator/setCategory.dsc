dd_SchematicEditor_SetCategory:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId|returnToMainMenu
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - narrate "<blue><italic> *** Click the category of this schematic"
    - define categoryList <util.list_files[schematics/dDungeon/]>
    - foreach <[categoryList]> as:cat:
        - if <[cat].starts_with[_]>:
            - foreach next
        - clickable dd_SchematicCreator_setProperty def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.settingName:category def.value:<[cat]> def.returnToMainMenu:<[returnToMainMenu].if_null[false]> for:<player> until:1m save:clickable
        - narrate "<blue><italic> *** <reset><gold>[<element[<[cat]>].on_click[<entry[clickable].command>]>]"
