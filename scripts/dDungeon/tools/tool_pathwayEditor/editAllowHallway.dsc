dd_PathwayEditor_PromptEditHallwayType:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - define sectionCategory <[optionsLoc].flag[dd_SectionOptions.category]>
    - define typeList <[sectionCategory].proc[dd_proc_ListHallwayTypes]>

    - narrate "<n><blue><italic> *** Click the Hallway Type this pathway should use, or click skip hallway below"
    - foreach <[typeList]> as:hallwayType:
        - clickable dd_PathwayEditor_EditHallwayType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.hallwayType:<[hallwayType]> def.clickableGroupId:<[clickableGroupId]> for:<player> until:1m save:clickType
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickType].id>
        - narrate "<blue><italic> *** <reset><gold>[<element[<[hallwayType]>].on_click[<entry[clickType].command>]>]"

    - clickable dd_PathwayEditor_EditHallwayType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.hallwayType:skip_hallway def.clickableGroupId:<[clickableGroupId]> for:<player> until:1m save:clickType
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickType].id>
    - narrate "<blue><italic> *** <reset><gold>[<element[SKIP HALLWAY].on_click[<entry[clickType].command>]>]"



dd_PathwayEditor_EditHallwayType:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|hallwayType|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.hallwayType:<[hallwayType]>
    - narrate "<blue><italic> *** Hallway Type set for Pathway"
    - wait 10t
    - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>

dd_proc_ListHallwayTypes:
    debug: false
    type: procedure
    definitions: category
    script:
    - define typeList <util.list_files[schematics/dDungeon/<[category]>]>
    - define outputList <list[]>
    - foreach <[typeList]> as:type:
        - if !<[type].starts_with[hallway_]>:
            - foreach next
        - define outputList:->:<[type].after[hallway_]>
    - determine <[outputList]>