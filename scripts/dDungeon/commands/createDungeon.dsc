dd_Create_Command:
    debug: false
    type: command
    name: ddCreate
    description: Admin - Create a dungeon (This is really only used for manual generation)
    usage: /ddCreate [DungeonType] [DungeonKey]
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    tab completions:
        1: <script[dd_DungeonSettings].data_key[dungeons].keys>
        2: <server.flag[dd_DungeonWorlds].keys.if_null[<list[]>]>
    script:
    #Get dungeon type
    - define dungeonType <context.args.first.if_null[null]>
    - define dungeonKey <context.args.get[2].if_null[null]>

    - if <[dungeonType]> == null:
        - narrate "<red> *** Specify a Dungeon Type to generate"
        - stop

    - if <[dungeonKey]> == null:
        - narrate "<red> *** A DungeonKey is required"
        - stop

    - if !<script[dd_DungeonSettings].data_key[dungeons].keys.contains[<[dungeonType]>]>:
        - narrate "<red> *** Dungeon Type doesn't exist: <[dungeonType]>"
        - stop

    - run dd_create def.dungeonType:<[dungeonType]> def.monitor:true def.dungeonKey:<[dungeonKey]>
