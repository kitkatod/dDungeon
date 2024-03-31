dd_SpawnTables_CleanupSpawnerBossbars:
    debug: false
    type: task
    script:
    - foreach <server.online_players_flagged[dd_bossbars]> as:player:
        - foreach <player.flag[dd_bossbars]> as:data key:bossbarId:
            - if <[data.location].world> !matches <[player].location.world> || <util.time_now.duration_since[<[data.last_checked]>]> >= 30s:
                - bossbar remove <[bossbarId]> players:<[player]>
                - flag <[player]> dd_bossbars.<[bossbarId]>:!

