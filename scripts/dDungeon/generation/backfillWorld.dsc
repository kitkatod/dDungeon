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
        - if !<[chunk].is_loaded>:
            - chunkload <[chunk]> duration:5s

        - define chunkCorner <[chunk].cuboid.min.with_y[<[minY]>]>
        - while <[chunkCorner].y> <= <[maxY]>:
            - schematic paste name:<[backfillSchematicName]> <[chunkCorner]> mask:air
            - define chunkCorner <[chunkCorner].add[0,16,0]>

        #Wait a tick after every chunk
        - wait 1t

    - wait 1t
    - ~schematic unload name:<[backfillSchematicName]>
