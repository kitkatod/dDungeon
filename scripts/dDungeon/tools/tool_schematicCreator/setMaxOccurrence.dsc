dd_SchematicEditor_SetMaxOccurrence:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Type in chat a new value for Max Occurrences for this section.<n>     (Set to -1 to remove a maximum limit)"
    - flag <player> dd_SchematicEditor_SetMaxOccurrence:<[optionsLoc]> expire:5m

dd_SchematicEditor_SetMaxOccurrence_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SchematicEditor_SetMaxOccurrence:
        - determine cancelled passively

        - define value <context.message>
        - if !<[value].is_integer>:
            - narrate "<red><italic> *** Entered value is not an integer"
            - stop
        - flag <player.flag[dd_SchematicEditor_SetMaxOccurrence]> dd_SectionOptions.maxOccurrenceCount:<[value]>
        - narrate "<blue><italic> *** Max Occurrences value set: <[value]>"
        - wait 1s
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<player.flag[dd_SchematicEditor_SetMaxOccurrence]>
        - flag <player> dd_SchematicEditor_SetMaxOccurrence:!
