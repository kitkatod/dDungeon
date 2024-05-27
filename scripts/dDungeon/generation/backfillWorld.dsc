dd_BackfillWorld:
    debug: false
    type: task
    definitions: world
    script:
    #Get cuboid of entire dungeon area
    - define totalCuboid <[world].flag[dd_totalAreaCuboid]>

    - define backfillSchematicName dd_worldbackfill_<[world].name>

    - define minY <[totalCuboid].min.y>
    - define maxY <[totalCuboid].max.y>

    #Loop through list of chunks needing to be updated
    - foreach <[totalCuboid].partial_chunks> as:chunk:
        #Load chunk if needed
        - define loadChunk !<[chunk].is_loaded>
        - if <[loadChunk]>:
            - chunkload <[chunk]> duration:5s

        #Fill the dungeon area within the chunk
        - define chunkCorner <[chunk].cuboid.min.with_y[<[minY]>]>
        - while <[chunkCorner].y> <= <[maxY]>:
            - schematic paste name:<[backfillSchematicName]> <[chunkCorner]> mask:air
            - define chunkCorner <[chunkCorner].add[0,16,0]>

        #Unload the chunk if we loaded it
        - if <[loadChunk]>:
            - chunkload remove <[chunk]>

        #Pause a tick every 5 chunks
        - if <[loop_index].mod[5]> == 0:
            - wait 1t

    - wait 1t
    - ~schematic unload name:<[backfillSchematicName]>
