dd_SpawnerEditor_ToggleSpawnEffects:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define value <[loc].flag[dd_spawner.do_spawn_effects].if_null[true].not>
    - flag <[loc]> dd_spawner.do_spawn_effects:<[value]>

    - narrate "<blue><italic> *** Spawner's Do Spawn Effects Setting: <reset><gold><[value]>"
    - wait 10t
    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>