dd_SpawnerEditor_SetBossbarTitle:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter a Title for the BossBar on this Spawner."
    - flag <player> dd_SpawnerEditor_SetBossbarTitle:<[loc]> expire:1m


dd_SpawnerEditor_SetBossbarTitle_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetBossbarTitle:
        - define loc <player.flag[dd_SpawnerEditor_SetBossbarTitle]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - flag <player> dd_SpawnerEditor_SetBossbarTitle:!
        - flag <[loc]> dd_spawner.bossbar_title:<[value]>

        - narrate "<blue><italic> *** Spawner's Bossbar Title Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>