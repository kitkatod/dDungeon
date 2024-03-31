dd_SpawnTables_SpawnEffects:
    debug: false
    type: task
    definitions: loc
    data:
        spawn_sounds:
        - AMBIENT_CAVE
    script:
    - playsound <[loc]> sound:<script.data_key[data.spawn_sounds].random> pitch:0.1 volume:2 sound_category:AMBIENT
    - repeat 20:
        - playeffect cloud at:<[loc].center> offset:3,3,3 quantity:2
        - wait 3t
