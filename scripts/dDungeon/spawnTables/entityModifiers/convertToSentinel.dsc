dd_SpawnTables_ConvertToSentinel:
    debug: false
    type: task
    definitions: entity|npcId
    script:
    - create <npc[<[npcId]>]> <[entity].name> save:entityNpc
    - adjust <queue> linked_npc:<entry[entityNpc].created_npc>

    #Add NPC to world's NPC list
    - flag <[entity].location.world> dd_npcs:->:<npc>

    #Move NPC (seems the create at location isn't really working as expected...)
    - spawn <npc> <[entity].location>

    #Copy entity type
    - adjust <npc> set_entity_type:<[entity].entity_type>

    #Copy equipment
    - adjust <npc> equipment:<[entity].equipment_map>
    - adjust <npc> item_in_hand:<[entity].item_in_hand>
    - adjust <npc> item_in_offhand:<[entity].item_in_offhand>

    #Copy flags
    - flag <npc> dd_spawnPoints:<[entity].flag[dd_spawnPoints]>

    - if <[entity].has_flag[dd_lootTable]>:
        - flag <npc> dd_lootTable:<[entity].flag[dd_lootTable]>

    #Remove original entity
    - remove <[entity]>

    - determine entity:<npc>
