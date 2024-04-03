dd_Transform_RotateAroundY:
    debug: false
    type: procedure
    definitions: sectionData|rotation
    script:
    #If rotation is 0, just return sectionData
    - if <[rotation]> == 0:
        - determine <[sectionData]>

    #Get radians to rotate location tags for simplicity
    - define rotRad <[rotation].to_radians.mul[-1]>

    #Get pathways map
    - define pathways <[sectionData.pathways].if_null[<map[]>]>
    - define newPathways <map[]>
    #Loop through each pathway, rotate around Y axis
    - foreach <[pathways].keys> as:pathKey:
        #Get path definition
        - define path <[pathways.<[pathKey]>]>
        #Rotate direction
        - define direction <[path.direction].rotate_around_y[<[rotRad]>].round>
        #Save direction
        - define path.direction <[direction]>

        #Rotate pathKey
        - define newPathKey <[pathKey].proc[dd_KeyToLocation].rotate_around_y[<[rotRad]>].proc[dd_LocationToKey]>
        #Save path definition
        - define newPathways.<[newPathKey]> <[path]>

    #Save new path data
    - define sectionData.pathways <[newPathways]>


    #Get inventories map
    - define inventories <[sectionData.inventories].if_null[<map[]>]>
    - define newInventories <map[]>
    #Loop through each inventory, rotate around Y axis
    - foreach <[inventories].keys> as:invKey:
        #Get inventory definition
        - define inv <[inventories.<[invKey]>]>
        #Rotate invKey
        - define newInvKey <[invKey].proc[dd_KeyToLocation].rotate_around_y[<[rotRad]>].proc[dd_LocationToKey]>
        #Save inv definition
        - define newInventories.<[newInvKey]> <[inv]>
    #Save new Inventories data
    - define sectionData.inventories <[newInventories]>

    #Flip pos1
    - define pos <[sectionData.pos1]>
    - define pos <[pos].rotate_around_y[<[rotRad]>].round>
    - define sectionData.pos1 <[pos]>

    #Flip pos2
    - define pos <[sectionData.pos2]>
    - define pos <[pos].rotate_around_y[<[rotRad]>].round>
    - define sectionData.pos2 <[pos]>

    #Flip flags
    - define flags <[sectionData.flags].if_null[<map[]>]>
    - define newFlags <map[]>
    - foreach <[flags]> as:flags_map key:flag_offset:
        #Rotate invKey
        - define newFlagOffset <[flag_offset].proc[dd_KeyToLocation].rotate_around_y[<[rotRad]>].proc[dd_LocationToKey]>
        #Save flag definition
        - define newFlags.<[newFlagOffset]> <[flags_map]>
    #Save new flags data
    - define sectionData.flags <[newFlags]>

    #Return new section data
    - determine <[sectionData]>