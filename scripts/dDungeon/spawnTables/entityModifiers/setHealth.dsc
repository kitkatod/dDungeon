dd_SpawnTables_SetHealth:
    debug: false
    type: task
    definitions: entity|healthMin|healthMax
    script:
    - define health <[healthMin].proc[dd_TrangularDistroRandomInt].context[<[healthMax]>]>

    - adjust <[entity]> max_health:<[health]>
    - adjust <[entity]> health:<[health]>