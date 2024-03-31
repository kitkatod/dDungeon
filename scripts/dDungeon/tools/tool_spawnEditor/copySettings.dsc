dd_SpawnerEditor_CopySettings:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <player> dd_SpawnerEditor_Settings:<[loc].flag[dd_spawner]> expire:1h

    - narrate "<blue> *** Spawner settings copied"
    - wait 10t

    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>