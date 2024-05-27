dd_BreakdownWorld:
    debug: false
    type: task
    definitions: world
    script:
    #Disable dungeon spawning in world
    - flag <[world]> dd_allowSpawning:false

    #Fire custom event for breaking down world
    - definemap context world:<[world]> dungeon_key:<[world].flag[dd_DungeonKey]>
    - customevent id:dd_dungeon_world_destroyed context:<[context]>

    #Teleport all players in the world out of the dungeon
    - foreach <[world].players> as:player:
        - ~run dd_ExitDungeon def.player:<[player]>

    #Teleport offline players that are in the dungeon
    - foreach <server.offline_players> as:player:
        - if <[player].location.world.if_null[null]> matches <[world]>:
            - ~run dd_ExitDungeon def.player:<[player]>

    #Remove all NPCs spawned into the world
    - foreach <[world].flag[dd_npcs].if_null[<list[]>]> as:npc:
        - remove <[npc]>

    #Remove exit area note
    - note remove as:dd_exitArea_<[world].name>

    #Remove reference of the world from the server
    - flag server dd_DungeonWorlds.<[world].flag[dd_DungeonKey]>:!

    #Brief pause between cleaning up everything (mainly teleporting players, and allowing any dungeon mob spawning to finish) before destroying
    - wait 2s

    #Destroy the world
    - adjust <[world]> destroy