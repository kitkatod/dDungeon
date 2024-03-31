dd_SpawnerEditor_PasteSettings:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - if !<player.has_flag[dd_SpawnerEditor_Settings]>:
        - narrate "<red> *** You do not have Spawner Settings copied."
        - stop

    - flag <[loc]> dd_spawner:<player.flag[dd_SpawnerEditor_Settings]>

    - narrate "<blue> *** Spawner settings copied"
    - wait 10t

    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>