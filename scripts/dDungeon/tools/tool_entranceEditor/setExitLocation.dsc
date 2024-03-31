dd_DungeonEntranceEditor_SetExitLocation:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Exit location set to your current location."
    - flag <[loc]> dd_entrance.exit_location:<player.location>

    - wait 10t
    - run dd_DungeonEntranceEditor_MainMenu def.loc:<[loc]>