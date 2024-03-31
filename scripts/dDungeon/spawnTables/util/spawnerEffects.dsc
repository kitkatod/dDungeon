dd_SpawnTables_SpawnerEffects:
    debug: false
    type: task
    definitions: loc
    script:
    - repeat 17:
        - playeffect MOBSPAWNER_FLAMES at:<[loc].center> offset:1 quantity:1
        - playeffect flame at:<[loc].center> offset:3 quantity:5
        - wait 7t
