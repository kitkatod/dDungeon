dd_PasteSchematicCommand:
    debug: false
    type: command
    name: ddPaste
    description: Admin - Place down a saved Dungeon Schematic
    usage: /ddPaste
    aliases:
    - placeSchematic
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    tab complete:
    - define input <context.raw_args.replace_text[\].with[/]>
    - if <[input].ends_with[/]>:
        - define input <[input].before_last[/]>
    - define tmp <util.list_files[schematics/<[input]>].if_null[<list[]>]>
    - if <[tmp].is_empty>:
        - define files <player.flag[dd_pasteSchematicList].if_null[<list[]>]>
    - else:
        - define files <list[]>
        - foreach <[tmp]> as:file:
            - if <[file].starts_with[_]>:
                - foreach next
            - define files:->:<[input]>/<[file]>
        - flag <player> dd_pasteSchematicList:<[files]> expire:30s

    - foreach <[files]> as:file:
        - if !<[file].advanced_matches[<[input]>*]> || <[file].ends_with[.yml]>:
            - define files:<-:<[file]>
    - determine <[files]>
    script:
    - define input <context.raw_args.replace_text[\].with[/]>
    - define input <[input].replace_text[.schem]>
    - define input <[input].replace_text[/schematics/]>
    - ~schematic load name:<[input]> filename:<[input]>
    - ~schematic paste name:<[input]> <player.location> entities delayed max_delay_ms:25
    - ~schematic unload name:<[input]>
    - narrate "<blue><italic> *** Pasted Schematic"
    - ~run dd_ShowSectionBlocks_Player def.user:<player>