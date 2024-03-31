dd_SpawnerEditor_SetSpawnerAreaMax:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter a decimal value for this Spawner's Area Spawn Point Max. This will be used to pause spawning with the Spawn Point of mobs in the area rises above this value."
    - flag <player> dd_SpawnerEditor_SetSpawnerAreaMax:<[loc]> expire:1m


dd_SpawnerEditor_SetSpawnerAreaMax_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetSpawnerAreaMax:
        - define loc <player.flag[dd_SpawnerEditor_SetSpawnerAreaMax]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Spawner Area Spawn Point Max value must be an integer or decimal <reset><red>(Value: <[value]>)"
        - else:
            - flag <player> dd_SpawnerEditor_SetSpawnerAreaMax:!
            - flag <[loc]> dd_spawner.area_max:<[value]>

        - narrate "<blue><italic> *** Spawner Area Spawn Point Max Value Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>