dd_SpawnerEditor_togglePreventDungeonSpawning:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[loc]> dd_spawner.prevent_dungeon_spawning_nearby:<[loc].flag[dd_spawner.prevent_dungeon_spawning_nearby].not>

    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>