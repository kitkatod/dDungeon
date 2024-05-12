dd_Create_Inventories:
    debug: false
    type: task
    definitions: world
    script:
    #Save a timestamp to compare against. Pause for a tick if we're spending more than 1 tick doing this.
    - define checkTime <util.time_now>

    #Process each queued inventory
    - while !<[world].flag[dd_inventory_queue].is_empty>:
        - if <[loop_index]> >= 1000:
            - narrate "<red><bold> *** STOPPING - Processed 1000 inventories"
            - while stop

        #If we're spending too much time, wait a tick to slow down a bit
        - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
            - wait 1t
            - define checkTime <util.time_now>

        - ~run dd_ProcessNextInventory def.world:<[world]>
        - flag <[world]> dd_inventoryCount:++


    #Process each special loot table
    - while !<[world].flag[dd_specialLootTables].keys.is_empty>:
        - if <[loop_index]> >= 1000:
            - narrate "<red><bold> *** STOPPING - Processed 1000 special inventory loot tables (somehow)"
            - while stop
        #If we're spending too much time, wait a tick to slow down a bit
        - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
            - wait 1t
            - define checkTime <util.time_now>
        - ~run dd_ProcessNextSpecialLootTable def.world:<[world]>

    #Process additional global loot tables
    - ~run dd_ProcessDungeonGlobalLoot def.world:<[world]>