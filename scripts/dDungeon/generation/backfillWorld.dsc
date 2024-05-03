dd_BackfillWorld:
    debug: false
    type: task
    definitions: world
    script:
    #Get cuboid of entire dungeon area
    - define totalCuboid <[world].flag[dd_totalAreaCuboid]>

    #Save a timestamp to compare against. Pause for a tick if we're spending more than 1 tick doing this.
    - define checkTime <util.time_now>

    #Loop through list of chunks needing to be updated
    - foreach <[totalCuboid].partial_chunks> as:chunk:
        #Load chunk if needed
        - if !<[chunk].is_loaded>:
            - chunkload <[chunk]> duration:10s

        #If we're spending too much time, wait a tick to slow down a bit
            - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
                - wait 1t
                - define checkTime <util.time_now>

        #Get part of cuboid that is inside chunk
        - define fillArea <[chunk].cuboid.intersection[<[totalCuboid]>]>

        #Get list of blocks to modify
        - define fillBlocks <[fillArea].blocks[air]>
        - if !<[fillBlocks].is_empty>:
            - ~modifyblock <[fillBlocks]> stone delayed max_delay_ms:30