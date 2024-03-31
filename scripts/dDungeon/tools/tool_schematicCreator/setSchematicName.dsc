dd_SchematicCreator_SetSchematicName_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SchematicEditor_SetSchematicName:
        - determine passively cancelled

        - define optionsLoc <player.flag[dd_SchematicEditor_SetSchematicName]>
        - define name <context.message>
        - if !<[name].regex_matches[([a-zA-Z_-]*)(_\d*)?$]>:
            - narrate "<red><italic> *** Schematic name can only contain A-Z, 0-9, _, or -. If any numbers are included they must be at the end, preceded with _.<n>     (For example: 'foo_bar', 'foobar', and 'foo_bar_123' are all valid, however 'foobar123' and 'foo_4U_123' are not)"
            - run dd_SchematicEditor_SetSchematicName def.optionsLoc:<[optionsLoc]>
            - stop

        - flag <player> dd_SchematicEditor_SetSchematicName:!
        - define optionsBlockData <[optionsLoc].flag[dd_SectionOptions]>
        - flag <[optionsLoc]> dd_SectionOptions.name:<[name]>
        - narrate "<blue><italic> *** Schematic Name Set: <reset><[name]>"

        - if <player.has_flag[dd_SchematicEditor_SetSchematicName_ReturnToMainMenu]>:
            - flag <player> dd_SchematicEditor_SetSchematicName_ReturnToMainMenu:!
            - wait 10t
            - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>


dd_SchematicEditor_SetSchematicName:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId|returnToMainMenu
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Type in chat the name of the schematic"
    - flag <player> dd_SchematicEditor_SetSchematicName:<[optionsLoc]> expire:5m

    - if <[returnToMainMenu].if_null[false]>:
        - flag <player> dd_SchematicEditor_SetSchematicName_ReturnToMainMenu:true expire:5m
