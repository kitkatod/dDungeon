dd_EnterDungeon:
    debug: false
    type: task
    definitions: dungeonKey|exitLocation
    script:
    #Get dungeon type
    - if <[dungeonKey].if_null[null]> == null:
        - narrate "<red> *** A DungeonKey is required"
        - stop

    #Get world reference
    - define world <server.flag[dd_DungeonWorlds.<[dungeonKey]>].if_null[null]>
    - if <[world]> == null:
        - narrate "<red> *** World for '<[dungeonKey]>' was not found"
        - stop

    - flag <player> dd_dungeonExit:<[exitLocation]>

    - define world <[world].as[world]>

    #Flag player with a cooldown while teleporting to prevent bouncing back out of the dungeon
    - flag <player> dd_enterExitCooldown expire:5s

    #Teleport player to configured point
    - teleport <player> <[world].flag[dd_DungeonSettings.entrancePoint]> cause:PLUGIN

    #Run custom event
    - define context <map[world=<[world]>;dungeon_key=<[dungeonKey]>]>
    - customevent id:dd_player_enters_dungeon context:<[context]>