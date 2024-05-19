dd_SpawnTables_CleanupSpawnerBossbars:
    debug: false
    type: task
    script:
    - foreach <server.online_players_flagged[dd_bossbars]> as:player:
        - foreach <[player].flag[dd_bossbars]> as:data key:bossbarId:
            - if <[data.location].world.name.if_null[null]> !matches <[player].location.world.name> || <util.time_now.duration_since[<[data.last_checked]>].in_ticks> >= 600:
                - bossbar remove <[bossbarId]> players:<[player]>
                - flag <[player]> dd_bossbars.<[bossbarId]>:!

