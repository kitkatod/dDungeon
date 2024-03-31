dd_QueueInventories:
    debug: false
    type: task
    definitions: loc|sectionOptions
    script:
    #Get options object
    - define inventories <[sectionOptions.inventories].if_null[<map[]>]>

    #Loop through each inventory configured
    - foreach <[inventories].keys> as:inventoryOffset:
        #Options for the current inventory
        - define inventoryOptions <[inventories.<[inventoryOffset]>]>

        #Find where inventory is located
        - define inventoryLoc <[loc].add[<[inventoryOffset]>]>

        #Dummy check - if there isn't an inventory here skip it
        - if !<[inventoryLoc].has_inventory>:
            - foreach next

        #Create a map with settings needed for this inventory
        - define inventoryQueueEntry <map[]>
        - define inventoryQueueEntry.location <[inventoryLoc]>
        - define inventoryQueueEntry.options <[inventoryOptions]>
        - define inventoryQueueEntry.sectionOptions <[sectionOptions]>

        #Add to list to be processed
        - flag <[loc].world> dd_inventory_queue:->:<[inventoryQueueEntry]>
        #Add to list of all inventories in the dungeon
        - flag <[loc].world> dd_all_inventories:->:<[inventoryLoc]>