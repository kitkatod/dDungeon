dd_BackfillWorld:
    debug: false
    type: task
    definitions: world|material
    script:
    #Get cuboid of entire dungeon area
    - define totalCuboid <[world].flag[dd_totalAreaCuboid]>

    #Loop through list of chunks needing to be updated
    - foreach <[totalCuboid].partial_chunks> as:chunk:
        #Load chunk if needed
        - if !<[chunk].is_loaded>:
            - chunkload <[chunk]> duration:10s

        #Get part of cuboid that is inside chunk
        - define fillArea <[chunk].cuboid.intersection[<[totalCuboid]>]>

        #Get list of blocks to modify
        - define fillBlocks <[fillArea].blocks[air]>
        - if !<[fillBlocks].is_empty>:
            - ~modifyblock <[fillBlocks]> <[material]> delayed max_delay_ms:40

        #Wait a tick after every chunk
        - wait 1t