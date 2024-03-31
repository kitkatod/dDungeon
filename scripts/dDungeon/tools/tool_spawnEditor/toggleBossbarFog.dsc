dd_SpawnerEditor_ToggleBossbarFog:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define value <[loc].flag[dd_spawner.bossbar_fog_enabled].if_null[true].not>
    - flag <[loc]> dd_spawner.bossbar_fog_enabled:<[value]>

    - narrate "<blue><italic> *** Spawner's Bossbar Fog Setting: <reset><gold><[value]>"
    - wait 10t
    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>