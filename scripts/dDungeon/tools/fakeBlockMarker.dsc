dd_FakeBlockMarker:
    debug: false
    type: item
    display name: <gold><italic>Dungeon Fake Block Wand
    material: barrier
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <reset><green>Use <gold><&keybind[key.use]> <green>to flag or unflag a block as a Fake Block<n><italic>Fake blocks will be converted to Block Display Entities during Dungeon Generation
    - <reset><green>Press <gold><&keybind[key.swapOffhand]> <green>to swap to Dungeon Entrance Marker
    flags:
        dd_show_fakeBlocks: true
        dd_toolswap_nexttool: dd_DungeonEntranceEditor
        dd_toolswap_previoustool: dd_InventoryEditor


dd_FakeBlockMarker_Events:
    debug: false
    type: world
    events:
        on player right clicks block with:dd_FakeBlockMarker:
        - determine cancelled passively
        - ratelimit <player> 10t
        - run dd_FakeBlockMarker_Toggle def.loc:<context.location>



dd_FakeBlockMarker_Toggle:
    debug: false
    type: task
    definitions: loc
    script:
    - if <[loc].has_flag[dd_fakeBlock]>:
        - flag <[loc]> dd_fakeBlock:!
    - else:
        - flag <[loc]> dd_fakeBlock

    - narrate "<blue> *** Toggled block as fake block (Enabled: <[loc].has_flag[dd_fakeBlock]>)"