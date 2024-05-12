dd_StandardSectionModifiers_ChangeBiome:
    debug: false
    type: task
    definitions: cuboid[Cuboid to apply the new Biome to]|biomeName[New Biome name to apply. For Custom Biomes, a Namespace must be included]
    script:
    - foreach <[cuboid].expand[5].blocks> as:cuboidBlock:
        - adjust <[cuboidBlock]> biome:<[biomeName].as[biome]>

    - foreach <[cuboid].expand[5].partial_chunks> as:cuboidChunk:
        - adjust <[cuboidChunk]> refresh_chunk