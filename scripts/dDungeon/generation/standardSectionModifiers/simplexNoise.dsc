dd_StandardSectionModifiers_SimplexNoise:
    debug: false
    type: task
    definitions: area[AreaTag to run noise generation over]|findMaterial[MaterialTag matcher for blocks to replace]|replacementMaterial[Material or list of Materials to use for replacement]|replacementMaterialRates[Rates passed to ModifyBlock for replacementMaterial]|wValue[w value used in random_simplex]|threshold[random_simplex threshold for a block to be changed. Between 0 and 1.]|scale[Value to multiply location coordinates by to get scaled simplex map location]
    script:
    #If scale isn't passed, just give a default
    - if !<[scale].exists>:
        - define scale 0.25

    #If threshold wasn't passed, just give a default
    - if !<[threshold].exists>:
        - define threshold 0.375

    #If wValue wasn't passed, just give a default
    - if !<[wValue].exists>:
        - define wValue 1

    #Loop through each matching block
    - define areaBlocks <[area].blocks[<[findMaterial]>]>
    - foreach <[areaBlocks]> as:blockLoc:
        #Simplex noise Mossy Stone
        - if <util.random_simplex[x=<[blockLoc].x.mul[<[scale]>]>;y=<[blockLoc].y.mul[<[scale]>]>;z=<[blockLoc].z.mul[<[scale]>]>;w=<[wValue]>].abs> >= <[threshold]>:
            - define bMat <[blockLoc].material>

            - if <[replacementMaterialRates].exists>:
                - ~modifyblock <[blockLoc]> <[replacementMaterial]> <[replacementMaterialRates]> no_physics
            - else:
                - ~modifyblock <[blockLoc]> <[replacementMaterial]> no_physics

            #Fix materials that need to be fixed (some materials lose their shape/waterlogged/etc properties)
            - if <[blockLoc].material> matches *_slab:
                - adjustblock <[blockLoc]> type:<[bMat].type>
                - adjustblock <[blockLoc]> waterlogged:<[bMat].waterlogged>
            - else if <[blockLoc].material> matches *_stairs:
                - adjustblock <[blockLoc]> shape:<[bMat].shape>
                - adjustblock <[blockLoc]> half:<[bMat].half>
                - adjustblock <[blockLoc]> direction:<[bMat].direction>
                - adjustblock <[blockLoc]> waterlogged:<[bMat].waterlogged>