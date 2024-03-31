dd_SpawnerEditor_SetSpawnTable:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - narrate "<n><blue><italic> *** Click on a Spawn Table below to apply it to this spawner."

    #Give a NULL option (just prevent spawning)
    - clickable dd_SpawnerEditor_SetSpawnTable_SelectTable def.loc:<[loc]> def.spawnTable:NULL_TABLE def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSpawnTable
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSpawnTable].id>
    - narrate "<blue> * <gold>[<element[NULL_TABLE].on_click[<entry[clickSpawnTable].command>].on_hover[This isn't a real table, it will just prevent spawning within the spawn radius]>]"

    #Get list of configured loot table categories
    - define spawnTables <script[dd_SpawnTables].data_key[spawnTables].keys>
    - foreach <[spawnTables]> as:spawnTable:
        - clickable dd_SpawnerEditor_SetSpawnTable_SelectTable def.loc:<[loc]> def.spawnTable:<[spawnTable]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSpawnTable
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSpawnTable].id>
        - narrate "<blue> * <gold>[<[spawnTable].on_click[<entry[clickSpawnTable].command>]>]"

    - narrate " "


dd_SpawnerEditor_SetSpawnTable_SelectTable:
    debug: false
    type: task
    definitions: loc|spawnTable|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[loc]> dd_spawner.spawn_table:<[spawnTable]>
    - narrate "<blue><italic> *** Spawn Table Set: <reset><gold><[spawnTable]>"
    - wait 10t
    - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>

