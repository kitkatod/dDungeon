dd_SpawnerEditor_SetSpawnerBank:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter a decimal value for this Spawner's Bank. This will be used to determine how many Spawn Points worth of mobs this Spawner can spawn.<n> *** Enter -1 to bypass the Spawner Bank functionality."
    - flag <player> dd_SpawnerEditor_SetSpawnerBank:<[loc]> expire:1m


dd_SpawnerEditor_SetSpawnerBank_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetSpawnerBank:
        - define loc <player.flag[dd_SpawnerEditor_SetSpawnerBank]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Spawner Bank value must be an integer or decimal <reset><red>(Value: <[value]>)"
        - else:
            - narrate "<blue><italic> *** Spawner Bank Value Set: <reset><gold><[value]>"
            - if <[value]> == -1:
                - define <[value]> null
            - flag <player> dd_SpawnerEditor_SetSpawnerBank:!
            - flag <[loc]> dd_spawner.bank:<[value]>

        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>