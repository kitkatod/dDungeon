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
    script:
    - run dd_PasteSchematic_Select

dd_PasteSchematic_Select:
    debug: false
    type: task
    definitions: category|type|schematicName
    script:
    #Missing category, show prompt for it
    - if !<[category].exists>:
        - narrate "<n><blue> *** Click Category to be pasted"
        - foreach <util.list_files[schematics/dDungeon].alphabetical> as:fileCategory:
            - clickable dd_PasteSchematic_Select def.category:<[fileCategory]> for:<player> usages:1 until:5m save:clickable
            - narrate "<blue> * <gold>[<[fileCategory].on_click[<entry[clickable].command>]>]"

    #Missing type, show prompt for it
    - else if !<[type].exists>:
        - narrate "<n><blue> *** Click Type to be pasted"
        - foreach <util.list_files[schematics/dDungeon/<[category]>].alphabetical> as:fileType:
            - clickable dd_PasteSchematic_Select def.category:<[category]> def.type:<[fileType]>  for:<player> usages:1 until:5m save:clickable
            - narrate "<blue> * <gold>[<[fileType].on_click[<entry[clickable].command>]>]"
    #Missing schematic name, prompt for it
    - else if !<[schematicName].exists>:
        - narrate "<n><blue> *** Click File to be pasted"
        - foreach <util.list_files[schematics/dDungeon/<[category]>/<[type]>/].filter_tag[<[filter_value].ends_with[.schem]>].alphabetical> as:fileName:
            - define fileName <[fileName].replace_text[.schem]>
            - clickable dd_PasteSchematic_Select def.category:<[category]> def.type:<[type]> def.schematicName:<[fileName]> for:<player> usages:1 until:5m save:clickable
            - narrate "<blue> * <gold>[<[fileName].on_click[<entry[clickable].command>]>]"
    #Nothing missing, paste schematic
    - else:
        - define file dDungeon/<[category]>/<[type]>/<[schematicName]>
        - define schemName ddTmp_<player.name>_pasteSchem
        - ~schematic load name:<[schemName]> filename:<[file]>
        - ~schematic paste name:<[schemName]> <player.location> entities delayed max_delay_ms:25
        - ~schematic unload name:<[schemName]>
        - narrate "<blue><italic> *** Pasted Schematic <[schematicName]> (Category: <[category]>) (Type: <[type]>)"
        - ~run dd_ShowSectionBlocks_Player def.user:<player>
