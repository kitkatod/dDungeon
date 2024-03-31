dd_SchematicEditor_SetDungeonEntrance:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    #Get selected options block data
    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>

    - if <[optionsData.type]> != spawn_room:
        - narrate "<red><italic> *** Only spawn rooms need to be marked with a Dungeon Entrance. Cancelled."
        - wait 1s
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>
        - stop

    - define relativeLoc <player.location.sub[<[optionsLoc]>].proc[dd_LocationWithoutWorld_KeepRotation]>
    - flag <[optionsLoc]> dd_SectionOptions.entrancePoint:<[relativeLoc]>

    - narrate "<blue> *** Dungeon entrance saved to your current position within the section"
    - wait 10t

    - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>
