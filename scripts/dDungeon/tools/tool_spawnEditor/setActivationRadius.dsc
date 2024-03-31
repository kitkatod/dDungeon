dd_SpawnerEditor_SetActivationRadius:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter an integer value for this Spawner's Activation Radius. Spawner will be active if any players are within this radius.<n> *** Alternatively, set to -1 to make spawner always active if any players are in the world."
    - flag <player> dd_SpawnerEditor_SetActivationRadius:<[loc]> expire:1m


dd_SpawnerEditor_SetActivationRadius_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetActivationRadius:
        - define loc <player.flag[dd_SpawnerEditor_SetActivationRadius]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Spawner Activation Radius value must be an integer or decimal <reset><red>(Value: <[value]>)"
        - else:
            - flag <player> dd_SpawnerEditor_SetActivationRadius:!
            - flag <[loc]> dd_spawner.activation_radius:<[value]>

        - narrate "<blue><italic> *** Spawner Activation Radius Value Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>