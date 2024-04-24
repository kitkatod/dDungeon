dd_ExitDungeon:
    debug: false
    type: task
    definitions: player
    script:
    - if <[player].exists>:
        - adjust <queue> linked_player:<[player]>

    - if <player.has_flag[dd_enterExitCooldown]>:
        - stop
    - flag <player> dd_enterExitCooldown expire:5s

    - define dungeonWorld <player.location.world>

    - define exitLoc <player.flag[dd_dungeonExit].if_null[<player.bed_spawn.if_null[<world[world].spawn_location>]>]>
    - flag <player> dd_dungeonExit:!

    - teleport <player> <[exitLoc]> cause:PLUGIN

    #Run custom event
    - define context <map[world=<[dungeonWorld]>]>
    - customevent id:dd_player_exits_dungeon context:<[context]>