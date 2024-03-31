dd_SpawnerEditor_SetSpawnerBudget:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter a decimal value for this Spawner's Budget. This will be used to determine how many Spawn Points worth of mobs this Spawner can spawn per spawn cycle."
    - flag <player> dd_SpawnerEditor_SetSpawnerBudget:<[loc]> expire:1m


dd_SpawnerEditor_SetSpawnerBudget_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetSpawnerBudget:
        - define loc <player.flag[dd_SpawnerEditor_SetSpawnerBudget]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Spawner Budget value must be an integer or decimal <reset><red>(Value: <[value]>)"
        - else:
            - flag <player> dd_SpawnerEditor_SetSpawnerBudget:!
            - flag <[loc]> dd_spawner.budget:<[value]>

        - narrate "<blue><italic> *** Spawner Budget Value Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>