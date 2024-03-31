dd_SchematicEditor_SetupNewOptionsBlock:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define map <map[]>
    - define map.pathways <map[]>
    - define map.inventories <map[]>
    - define map.chance 100
    - define map.maxOccurrenceCount -1

    - flag <[optionsLoc]> dd_SectionOptions:<[map]>

    - run dd_SchematicEditor_SetCategory def.optionsLoc:<[optionsLoc]>
    - waituntil <[optionsLoc].flag[dd_SectionOptions.category].if_null[].length> > 0 rate:10t max:1m

    - run dd_SchematicEditor_SetType def.optionsLoc:<[optionsLoc]>
    - waituntil <[optionsLoc].flag[dd_SectionOptions.type].if_null[].length> > 0 rate:10t max:1m

    - run dd_SchematicEditor_SetSchematicName def.optionsLoc:<[optionsLoc]>
    - waituntil <[optionsLoc].flag[dd_SectionOptions.name].if_null[].length> > 0 rate:10t max:1m

    - ~run dd_SchematicEditor_AutoSetSectionArea def.optionsLoc:<[optionsLoc]>

    - narrate "<n><blue><italic> *** Quick Setup Complete"
    - wait 10t

    - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>