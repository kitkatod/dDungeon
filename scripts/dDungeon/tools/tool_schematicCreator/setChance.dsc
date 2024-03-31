dd_SchematicEditor_SetChance:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter a decimal chance value for this section to be placed.<n>     This chance will be weighted against other sections of the same type during Dungeon Generation."
    - flag <player> dd_SchematicEditor_SetChance:<[optionsLoc]> expire:1m


dd_SchematicEditor_SetChanceEvents:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SchematicEditor_SetChance:
        - define optionsLoc <player.flag[dd_SchematicEditor_SetChance]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Chance value must be an integer <reset><red>(Value: <[value]>)"
        - else:
            - flag <player> dd_SchematicEditor_SetChance:!
            - flag <[optionsLoc]> dd_SectionOptions.chance:<[value]>

        - narrate "<blue><italic> *** Section Chance Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>