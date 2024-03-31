dd_DungeonEntranceEditor_SetDungeonKey:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define dungeonKeys <server.flag[dd_DungeonWorlds].keys.if_null[<list[]>]>
    - if <[dungeonKeys].is_empty>:
        - narrate "<n><red><italic> *** No dungeons have been created yet. Use /ddCreate to setup a dungeon first, then you can create an entrance."
        - stop

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - narrate "<n><blue><italic> *** Click below on the DungeonKey of an existing dungeon. This entrance will be connected to that dungeon."
    - foreach <[dungeonKeys]> as:dungeonKey:
        - clickable dd_DungeonEntranceEditor_SetDungeonKeyValue def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> def.dungeonKey:<[dungeonKey]> usages:1 for:<player> until:5m save:clickDungeonKey
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDungeonKey].id>
        - narrate "<blue> * <gold>[<[dungeonKey].on_click[<entry[clickDungeonKey].command>]>]"

dd_DungeonEntranceEditor_SetDungeonKeyValue:
    debug: false
    type: task
    definitions: loc|clickableGroupId|dungeonKey
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Dungeon Key set for Entrance: <gold><[dungeonKey]>"
    - wait 10t
    - flag <[loc]> dd_entrance.dungeon_key:<[dungeonKey]>

    - run dd_DungeonEntranceEditor_MainMenu def.loc:<[loc]>
