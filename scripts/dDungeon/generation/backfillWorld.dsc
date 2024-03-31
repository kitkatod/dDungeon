dd_BackfillWorld:
    debug: false
    type: task
    definitions: world
    script:
    #Get cuboid of entire dungeon area
    - define totalCuboid <[world].flag[dd_totalAreaCuboid]>

    #Get min/max corners of totalCuboid
    - define minCorner <[totalCuboid].corners.get[1]>
    - define maxCorner <[totalCuboid].corners.get[8]>

    #Segment area into smaller pieces to backfill remaining open air
    - define z <[minCorner].z>
    - while <[z]> <= <[maxCorner].z>:
        - define x <[minCorner].x>
        - while <[x]> <= <[maxCorner].x>:
            - define loc <location[<[x]>,<[minCorner].y>,<[z]>].with_world[<[world]>]>
            - define cuboid <[loc].to_cuboid[<[loc].add[20,0,20].with_y[<[maxCorner].y>]>]>
            - chunkload <[cuboid].partial_chunks> duration:10s
            - define replaceBlocks <[cuboid].blocks[air]>
            - if !<[replaceBlocks].is_empty>:
                - ~modifyblock <[replaceBlocks]> stone delayed max_delay_ms:30
            - define x:+:20
        - define z:+:20
        #Wait a tick every once in awhile
        - if <[loop_index].mod[5]> == 0:
            - wait 1t
