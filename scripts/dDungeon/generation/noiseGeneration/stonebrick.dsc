dd_NoiseGeneration_Stonebrick:
    debug: false
    type: task
    definitions: cuboid|type
    script:
    - if <[type].ends_with[_crypt]>:
        - define replaceBlocks <[cuboid].blocks[nether_bricks]>
        - if !<[replaceBlocks].is_empty>:
            - ~modifyblock <[replaceBlocks]> nether_bricks|cracked_nether_bricks 50|50 delayed no_physics

        - define replaceBlocks <[cuboid].blocks[deepslate_bricks]>
        - if !<[replaceBlocks].is_empty>:
            - ~modifyblock <[replaceBlocks]> deepslate_bricks|cracked_deepslate_bricks|deepslate 50|40|10 delayed no_physics

        - define replaceBlocks <[cuboid].blocks[obsidian]>
        - if !<[replaceBlocks].is_empty>:
            - ~modifyblock <[replaceBlocks]> obsidian|crying_obsidian 65|35 delayed no_physics
    - else:
        - define replaceBlocks <[cuboid].blocks[stone_bricks]>
        - if !<[replaceBlocks].is_empty>:
            - ~modifyblock <[replaceBlocks]> stone_bricks|stone|smooth_stone|cobblestone 85|7|6|2 delayed no_physics

    - define cuboidBlocks <[cuboid].blocks[stone_bricks|stone_brick_slab|stone_brick_stairs|netherrack]>
    - foreach <[cuboidBlocks]> as:blockLoc:
        #Simplex noise Mossy Stone
        - if <util.random_simplex[x=<[blockLoc].x.mul[0.25]>;y=<[blockLoc].y.mul[0.25]>;z=<[blockLoc].z.mul[0.25]>;w=1]> > 0.25:
            - choose <[blockLoc].material.name>:
                - case stone_bricks:
                    - ~modifyblock <[blockLoc]> mossy_stone_bricks|cracked_stone_bricks 90|10 no_physics
                - case stone_brick_slab:
                    - define bMat <[blockLoc].material>
                    - ~modifyblock <[blockLoc]> mossy_stone_brick_slab|andesite_slab|stone_slab 90|5|5 no_physics
                    - adjustblock <[blockLoc]> type:<[bMat].type>
                    - adjustblock <[blockLoc]> waterlogged:<[bMat].waterlogged>
                - case stone_brick_stairs:
                    - define bMat <[blockLoc].material>
                    - ~modifyblock <[blockLoc]> mossy_stone_brick_stairs|andesite_stairs|stone_stairs 90|5|5 no_physics
                    - adjustblock <[blockLoc]> shape:<[bMat].shape>
                    - adjustblock <[blockLoc]> half:<[bMat].half>
                    - adjustblock <[blockLoc]> direction:<[bMat].direction>
                    - adjustblock <[blockLoc]> waterlogged:<[bMat].waterlogged>
                - case netherrack:
                    - ~modifyblock <[blockLoc]> nether_gold_ore no_physics

        #Simplex noise Cracked Stone
        - if <util.random_simplex[x=<[blockLoc].x.mul[0.25]>;y=<[blockLoc].y.mul[0.25]>;z=<[blockLoc].z.mul[0.25]>;w=2]> > 0.25:
            - choose <[blockLoc].material.name>:
                - case stone_bricks:
                    - ~modifyblock <[blockLoc]> cracked_stone_bricks|mossy_stone_bricks 90|10 no_physics
                - case stone_brick_slab:
                    - define bMat <[blockLoc].material>
                    - ~modifyblock <[blockLoc]> andesite_slab|stone_slab|mossy_stone_brick_slab 45|45|10 no_physics
                    - adjustblock <[blockLoc]> type:<[bMat].type>
                    - adjustblock <[blockLoc]> waterlogged:<[bMat].waterlogged>
                - case stone_brick_stairs:
                    - define bMat <[blockLoc].material>
                    - ~modifyblock <[blockLoc]> andesite_stairs|stone_stairs|mossy_stone_brick_stairs 45|45|10 no_physics
                    - adjustblock <[blockLoc]> shape:<[bMat].shape>
                    - adjustblock <[blockLoc]> half:<[bMat].half>
                    - adjustblock <[blockLoc]> direction:<[bMat].direction>
                    - adjustblock <[blockLoc]> waterlogged:<[bMat].waterlogged>
                - case netherrack:
                    - ~modifyblock <[blockLoc]> nether_quartz_ore no_physics

    - if <[type].ends_with[_crypt]>:
        - foreach <[cuboid].expand[5].blocks> as:cuboidBlock:
            - adjust <[cuboidBlock]> biome:<biome[dc:crypt]>
    - else:
        - foreach <[cuboid].expand[5].blocks> as:cuboidBlock:
            - adjust <[cuboidBlock]> biome:<biome[dc:sewer]>

    - foreach <[cuboid].expand[5].partial_chunks> as:cuboidChunk:
        - adjust <[cuboidChunk]> refresh_chunk
    - foreach <[cuboid].blocks_flagged[dd_fakeBlock]> as:cuboidBlock:
        - flag <[cuboidBlock]> dd_fakeBlock:!
        - spawn block_display[material=<[cuboidBlock].material>] <[cuboidBlock].round_down> persistent reason:CUSTOM
        - ~modifyblock <[cuboidBlock]> cave_air no_physics

    - define replaceBlocks <[cuboid].blocks[air]>
    - if !<[replaceBlocks].is_empty>:
        - ~modifyblock <[replaceBlocks]> cave_air delayed no_physics
