dd_StandardSectionModifiers_ChangeBiome:
    debug: false
    type: task
    definitions: area|biomeName
    script:
    - foreach <[area].expand[5].blocks> as:cuboidBlock:
        - adjust <[cuboidBlock]> biome:<[biomeName].as[biome]>

    - foreach <[area].expand[5].partial_chunks> as:cuboidChunk:
        - adjust <[cuboidChunk]> refresh_chunk