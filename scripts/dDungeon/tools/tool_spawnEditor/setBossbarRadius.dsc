dd_SpawnerEditor_SetBossbarRadius:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter an integer value for this Spawner's Bossbar Radius. Players within this radius will be displayed the bossbar, if enabled."
    - flag <player> dd_SpawnerEditor_SetBossbarRadius:<[loc]> expire:1m


dd_SpawnerEditor_SetBossbarRadius_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetBossbarRadius:
        - define loc <player.flag[dd_SpawnerEditor_SetBossbarRadius]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<[value].is_decimal>:
            - narrate "<red><italic> *** Spawner's Spawn Radius value must be an integer or decimal <reset><red>(Value: <[value]>)"
        - else:
            - flag <player> dd_SpawnerEditor_SetBossbarRadius:!
            - flag <[loc]> dd_spawner.bossbar_radius:<[value]>

        - narrate "<blue><italic> *** Spawner's Bossbar Radius Value Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>