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

    - define sectionCount 0

    #Loop through list of chunks needing to be updated
    - foreach <[totalCuboid].partial_chunks> as:chunk:
        #Load chunk if needed
        - define loadChunk !<[chunk].is_loaded>
        - if <[loadChunk]>:
            - chunkload <[chunk]> duration:5s

        #Fill the dungeon area within the chunk
        - define chunkCorner <[chunk].cuboid.min.with_y[<[minY]>]>
        - while <[chunkCorner].y> <= <[maxY]>:
            - if <[sectionCount]> >= 10:
                - wait 1t
                - define sectionCount 0

            - schematic paste name:<[backfillSchematicName]> <[chunkCorner]> mask:air
            - define chunkCorner <[chunkCorner].add[0,16,0]>

            - define sectionCount:++

        #Unload the chunk if we loaded it
        - if <[loadChunk]>:
            - chunkload remove <[chunk]>

    - wait 1t
    - ~schematic unload name:<[backfillSchematicName]>
