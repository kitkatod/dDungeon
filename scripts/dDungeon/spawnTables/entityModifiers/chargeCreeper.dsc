dd_SpawnTables_chargeCreeper:
    debug: false
    type: task
    definitions: entity
    script:
    - strike <[entity].location> no_damage
    - adjust <[entity]> powered:true
    - flag <[entity]> dd_spawnPoints:+:5