dd_Transform_FlipOverX:
    debug: false
    type: procedure
    definitions: sectionData
    script:
    #Get pathways map
    - define pathways <[sectionData.pathways].if_null[<map[]>]>
    - define newPathways <map[]>
    #Loop through each pathway, flip over X axis
    - foreach <[pathways].keys> as:pathKey:
        #Get path definition
        - define path <[pathways.<[pathKey]>]>
        #Get direction
        - define direction <[path.direction]>
        #Flip direction
        - define direction <[direction].with_z[<[direction].z.mul[-1]>]>
        #Save direction
        - define path.direction <[direction]>

        #Flip pathKey
        - define pathKeyLoc <[pathKey].proc[dd_KeyToLocation]>
        - define newPathKey <[pathKeyLoc].with_z[<[pathKeyLoc].z.mul[-1]>].proc[dd_LocationToKey]>
        #Save path definition
        - define newPathways.<[newPathKey]> <[path]>

    #Save new path data
    - define sectionData.pathways <[newPathways]>

    #Get inventories map
    - define inventories <[sectionData.inventories].if_null[<map[]>]>
    - define newInventories <map[]>
    #Loop through each inventory, flip over X axis
    - foreach <[inventories].keys> as:invKey:
        #Get inventory definition
        - define inv <[inventories.<[invKey]>]>
        #Flip invKey
        - define invKeyLoc <[invKey].proc[dd_keytolocation]>
        - define newInvKey <[invKeyLoc].with_z[<[invKeyLoc].z.mul[-1]>].proc[dd_LocationToKey]>
        #Save inv definition
        - define newInventories.<[newInvKey]> <[inv]>
    #Save new Inventories data
    - define sectionData.inventories <[newInventories]>

    #Flip pos1
    - define pos <[sectionData.pos1]>
    - define pos <[pos].with_z[<[pos].z.mul[-1]>]>
    - define sectionData.pos1 <[pos]>

    #Flip pos2
    - define pos <[sectionData.pos2]>
    - define pos <[pos].with_z[<[pos].z.mul[-1]>]>
    - define sectionData.pos2 <[pos]>

    #Flip entrance
    - if <[sectionData.entrancePoint].exists>:
        - define sectionData.entrancePoint <[sectionData.entrancePoint].with_z[<[sectionData.entrancePoint].z.mul[-1]>]>

    #Return new section data
    - determine <[sectionData]>