dd_ShowSectionBlocks_SpawnMarkerTitle:
    debug: false
    type: task
    definitions: markerBlock|title
    script:
    - if <[markerBlock].up[1]> !matches air && <[markerBlock].down[1]> matches air:
        - define titleLoc <[markerBlock].down[1].center>
    - else:
        - define titleLoc <[markerBlock].up[1].center>


    - fakespawn dd_ShowSectionBlocks_TitleDisplay[text=<[title]>] <[titleLoc]> duration:3.25s save:displayEntity
    # - adjust <entry[displayEntity].faked_entity> text:<[title]>

dd_ShowSectionBlocks_TitleDisplay:
    debug: false
    type: entity
    entity_type: text_display
    mechanisms:
        text: PLACEHOLDER
        pivot: center
        see_through: true
        text_shadowed: false