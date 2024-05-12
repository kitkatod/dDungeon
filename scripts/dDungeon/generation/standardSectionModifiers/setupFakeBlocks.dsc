dd_StandardSectionModifiers_SetupFakeBlocks:
    debug: false
    type: task
    definitions: area
    script:
    - foreach <[area].blocks_flagged[dd_fakeBlock]> as:cuboidBlock:
        - flag <[cuboidBlock]> dd_fakeBlock:!
        - spawn block_display[material=<[cuboidBlock].material>] <[cuboidBlock].round_down> persistent reason:CUSTOM
        - ~modifyblock <[cuboidBlock]> cave_air no_physics