dd_SchematicEditor_SetDungeonExitRadius:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter an integer value for this Spawn Room's Exit Radius. Players entering this radius from the Entrance Point will leave the dungeon."
    - flag <player> dd_SchematicEditor_SetDungeonExitRadius:<[loc]> expire:1m


dd_SchematicEditor_SetDungeonExitRadius_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SchematicEditor_SetDungeonExitRadius:
        - define loc <player.flag[dd_SchematicEditor_SetDungeonExitRadius]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Spawn Room's Exit Radius value must be an integer or decimal <reset><red>(Value: <[value]>)"
        - else:
            - flag <player> dd_SchematicEditor_SetDungeonExitRadius:!
            - flag <[loc]> dd_SectionOptions.exitRadius:<[value]>

        - narrate "<blue><italic> *** Spawn Room's Exit Radius Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SchematicEditor_MainMenu def.loc:<[loc]>