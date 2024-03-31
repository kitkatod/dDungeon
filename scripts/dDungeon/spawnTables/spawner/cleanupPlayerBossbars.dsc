dd_SpawnTables_CleanupSpawnerBossbars:
    debug: false
    type: task
    script:
    - foreach <server.players> as:player:
        - foreach <player.flag[bossbarPlayers].if_null[<map[]>]> as:data key:bossbarId:
            - if <[data.location].world> !matches <[player].location.world> || <util.time_now.duration_since[<[data.last_checked]>]> >= 30s:
                - bossbar remove <[bossbarId]> players:<[player]>
                - flag <[player]> bossbarPlayers.<[bossbarId]>:!

