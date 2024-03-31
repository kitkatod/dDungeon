dd_Destroy_Command:
    debug: false
    type: command
    name: ddDestroy
    description: Admin - Destroy a dungeon world
    usage: /ddDestroy [DungeonKey]
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    tab completions:
        1: <server.flag[dd_DungeonWorlds].keys.if_null[<list[]>]>
    script:
    #Get dungeon type
    - define dungeonKey <context.args.first.if_null[null]>

    - if <[dungeonKey]> == null:
        - narrate "<red> *** A DungeonKey is required"
        - stop

    - define world <server.flag[dd_DungeonWorlds.<[dungeonKey]>].if_null[null]>
    - if <[world]> == null:
        - narrate "<red> *** World <[world]> is not loaded"
        - stop

    - define world <[world].as[world]>

    #Kick any players out of the dungeon to the exit location
    # # - if !<[world].players.is_empty>:
    # #     - teleport <[world].players> 

    - run dd_BreakdownWorld def.world:<[world]>

    - narrate "<gold> *** World destroyed"
