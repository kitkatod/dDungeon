dd_rollLootTable_Inventory:
    debug: false
    type: task
    definitions: inventory|categories
    script:
    #Get items based on categories
    - define invItems <list[]>
    - foreach <[categories]> as:cat:
        - foreach <[cat].proc[dd_RollLootTable_Category].if_null[<list[]>]> as:item:
            - define invItems:->:<[item]>

    #If inventory has a location and the chunk isn't loaded, load it
    - if !<[inventory].location.chunk.is_loaded.if_null[true]>:
        - chunkload <[inventory].location.chunk> duration:10s


    - choose <[inventory].inventory_type>:
        #Custom logic specific for furnaces to allow "putting fuel in the fuel hole"
        - case FURNACE BLAST_FURNACE:
            - foreach <[invItems]> as:item:
                #If fuel slot is empty and the item is fuel put it in the fuel hole
                - if <[item].material.is_fuel> && <[inventory].slot[2]> matches air:
                    - inventory set destination:<[inventory]> slot:2 origin:<[item]>
                #If the "burn the stuff" slot is empty, put it there
                - else if <[inventory].slot[1]> matches air:
                    - inventory set destination:<[inventory]> slot:1 origin:<[item]>
                #NOTE - items can be "lost" from the loot roll easily here if too many items are passed into the task
        - default:
            #Place items into empty slots
            - define emptySlots <[inventory].find_empty_slots>
            #TODO - Do a check on empty slot count. If there are more items listed than there are slots, combine items in the list that can be combined so we don't run out of space in the inventory
            - foreach <[invItems]> as:item:
                #No more empty slots available, just exit
                - if <[emptySlots].is_empty>:
                    - foreach stop

                - define invSlot <[emptySlots].random>
                - define emptySlots:<-:<[invSlot]>
                - inventory set destination:<[inventory]> slot:<[invSlot]> origin:<[item]>