dd_GenerationEvents:
    debug: false
    type: world
    events:
        after custom event id:dd_dungeon_section_placed priority:100:
        - ~run dd_StandardSectionModifiers_SetupFakeBlocks def.area:<context.area>
        - ~run dd_StandardSectionModifiers_ChangeAirToCaveair def.area:<context.area>