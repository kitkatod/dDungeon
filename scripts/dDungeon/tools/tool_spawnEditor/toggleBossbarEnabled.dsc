dd_SpawnerEditor_ToggleBossbarEnabled:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define value <[loc].flag[dd_spawner.bossbar_enabled].if_null[false].not>
    - flag <[loc]> dd_spawner.bossbar_enabled:<[value]>

    - narrate "<blue><italic> *** Spawner's Bossbar Enabled Setting: <reset><gold><[value]>"
    - wait 10t
    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>
