dd_StandardSectionModifiers_ChangeAirToCaveair:
    debug: false
    type: task
    definitions: area
    script:
    - define replaceBlocks <[area].blocks[air]>
    - if !<[replaceBlocks].is_empty>:
        - ~modifyblock <[replaceBlocks]> cave_air delayed no_physics