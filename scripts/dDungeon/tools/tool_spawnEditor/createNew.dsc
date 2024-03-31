dd_SpawnerEditor_CreateNew:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[loc]> dd_spawner:<map[spawn_table=generic;bank=50;budget=10;area_max=20;spawn_radius=10;activation_radius=20;prevent_dungeon_spawning_nearby=false;entities=<list[]>]>

    - narrate "<blue> *** Spawner has been created"
    - run dd_ShowSectionBlocks_Player def.user:<player>
    - wait 10t

    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>