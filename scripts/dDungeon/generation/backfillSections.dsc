dd_BackfillSections:
    debug: false
    type: task
    definitions: world|material
    script:
    #Get "dungeon" cuboid (cuboid with many subcuboids, one for each section)
    - define dcArea <cuboid[<[world].name>_dcarea]>

    - define totalCuboid <[dcArea].get[1]>

    #Save a timestamp to compare against. Pause for a tick if we're spending more than 1 tick doing this.
    - define checkTime <util.time_now>

    - foreach <[dcArea].list_members> as:cuboidMember:
        #Get a copy of dcArea without this cuboid member. This will be used to avoid flood filling from cuboid corners that overlap another section.
        #This has the potential of causing a section to not be flood filled, however it would require all 8 corners to be overlapping in most cases.
        - define cornerTestCuboid <[dcArea].remove_member[<[loop_index]>].if_null[ONLY_SECTION]>

        #Make sure the chunk is loaded
        - chunkload add <[cuboidMember].partial_chunks> duration:5s

        #Expand total bounding box of the dungeon. This will be used later for the "total world" backfill
        - define totalCuboid <[totalCuboid].include[<[cuboidMember]>]>

        #Flood fill from each corner
        - foreach <[cuboidMember].outline> as:outlinePoint:
            #Check if outlinePoint is an air block
            - if <[outlinePoint]> matches *air:
                #Check if outlinePoint is outside all other placed sections, OR if this is the only section placed in the dungeon
                - if <[cornerTestCuboid]> == ONLY_SECTION || !<[cornerTestCuboid].contains[<[outlinePoint]>]>:
                    #If we're spending too much time, wait a tick to slow down a bit
                    - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
                        - wait 1t
                        - define checkTime <util.time_now>
                    - ~run dd_FloodfillArea def.area:<[cuboidMember]> def.location:<[outlinePoint]> def.matcher:*air def.material:<[material]>

        #Slowing down just a bit when it places blocks. Have seen some massive lag/server crash otherwise
        - if <[loop_index].mod[10]> == 0:
            - wait 1t

    #Get a single cuboid covering entire area of the dungeon, with a buffer on all sides
    - define totalCuboid <[totalCuboid].expand_one_side[20,20,20]>
    - define totalCuboid <[totalCuboid].expand_one_side[-20,-20,-20]>
    - flag <[world]> dd_totalAreaCuboid:<[totalCuboid]>