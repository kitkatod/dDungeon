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

    #Simplex noise Mossy Stone
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:stone_bricks def.replacementMaterial:mossy_stone_bricks|cracked_stone_bricks def.replacementMaterialRates:90|10 def.wValue:1 def.threshold:0.375
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:stone_brick_slab def.replacementMaterial:mossy_stone_brick_slab|andesite_slab|stone_slab def.replacementMaterialRates:90|5|5 def.wValue:1 def.threshold:0.375
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:stone_brick_stairs def.replacementMaterial:mossy_stone_brick_stairs|andesite_stairs|stone_stairs def.replacementMaterialRates:90|5|5 def.wValue:1 def.threshold:0.375
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:netherrack def.replacementMaterial:nether_gold_ore def.wValue:1 def.threshold:0.375

    #Simplex noise Cracked Stone
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:stone_bricks def.replacementMaterial:cracked_stone_bricks|mossy_stone_bricks def.replacementMaterialRates:90|10 def.wValue:2 def.threshold:0.375
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:stone_brick_slab def.replacementMaterial:andesite_slab|stone_slab|mossy_stone_brick_slab def.replacementMaterialRates:45|45|10 def.wValue:2 def.threshold:0.375
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:stone_brick_stairs def.replacementMaterial:andesite_stairs|stone_stairs|mossy_stone_brick_stairs def.replacementMaterialRates:45|45|10 def.wValue:2 def.threshold:0.375
    - ~run dd_StandardSectionModifiers_SimplexNoise def.area:<[cuboid]> def.findMaterial:netherrack def.replacementMaterial:nether_quartz_ore def.wValue:2 def.threshold:0.375

    - if <[type].ends_with[_crypt]>:
        - run dd_StandardSectionModifiers_ChangeBiome def.area:<[cuboid]> def.biomeName:dc:crypt
    - else:
        - run dd_StandardSectionModifiers_ChangeBiome def.area:<[cuboid]> def.biomeName:dc:sewer
