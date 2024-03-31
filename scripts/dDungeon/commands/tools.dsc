dd_GiveToolsCommand:
    debug: false
    type: command
    name: ddTools
    description: Admin - Give yourself a Dungeon Schematic Tools
    usage: /ddTools
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    script:
    - give dd_SchematicEditor
    - give dd_pathwayeditor