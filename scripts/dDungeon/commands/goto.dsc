dd_GoToDungeonCommand:
    debug: false
    type: command
    name: ddGoTo
    description: Admin - Teleport to a specified, already generated dungeon
    usage: /ddGoTo [DungeonKey]
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    tab completions:
        1: <server.flag[dd_DungeonWorlds].keys.if_null[<list[]>]>
    script:
    #Get dungeon type
    - define dungeonKey <context.args.first.if_null[null]>
    - run dd_EnterDungeon def.dungeonKey:<[dungeonKey]> def.exitLocation:<player.location>