dd_Events:
    debug: false
    type: world
    events:
        #Load existing Dungeon Worlds at server start
        after server start:
        - foreach <server.flag[dd_DungeonWorlds].if_null[<map[]>]> as:worldName key:dungeonKey:
            - if <[worldName]> == null:
                - foreach next
            - createworld <[worldName]> generator:denizen:void

        #Prevent TNT/Creeper griefs
        on block destroyed by explosion in:world_flagged:dd_DungeonSettings:
        - determine cancelled

        #Prevent survival players from breaking dungeon blocks
        on player breaks block in:world_flagged:dd_DungeonSettings:
        - if <player.gamemode> == survival && <context.location> !matches ladder|*torch|decorated_pot|cobweb|amethyst_cluster|*lantern|chain|*candle|*fire|player_head:
            - determine cancelled passively
            - ratelimit <player> 10t
            - narrate "<italic><dark_red> * You can't break that here (<context.location.material.name>)"

        #Prevent survival players from placing blocks in dungeon
        on player places block in:world_flagged:dd_DungeonSettings:
        - if <player.gamemode> == survival && <context.material> !matches ladder|*torch|*lantern|chain|*candle:
            - determine cancelled passively
            - ratelimit <player> 10t
            - narrate "<italic><dark_red> * You can't place that here (<context.material.name>)"

        #Prevent natural spawning in dungeon worlds
        on entity spawns because NATURAL in:world_flagged:dd_DungeonSettings:
        - determine cancelled

        #Prevent picking up wither roses from pots
        on player right clicks potted_wither_rose in:world_flagged:dd_DungeonSettings:
        - if <player.gamemode> == survival:
            - determine cancelled passively
            - ratelimit <player> 10t
            - narrate "<italic><dark_red> * Sorry, that's just for show."

        #Disallow setting spawn location in dungeon
        on player right clicks *bed in:world_flagged:dd_DungeonSettings:
        - narrate "<dark_red> * It's not safe to sleep here"
        - determine cancelled


        #Remove dungeon entrance if the block is broken
        on player breaks block location_flagged:dd_entrance:
        - flag <context.location> dd_entrance:!
        on player breaks block location_flagged:dd_entrance_otherblock:
        - flag <context.location> dd_entrance_otherblock:!

        #Enter dungeon
        on player right clicks block location_flagged:dd_entrance:
        - ratelimit <player> 1t
        - if <player.item_in_hand> matches dd_DungeonentranceEditor:
            - stop

        - define data <context.location.flag[dd_entrance]>
        - run dd_EnterDungeon def.dungeonKey:<[data.dungeon_key]> def.exitLocation:<[data.exit_location].if_null[<player.location>]>
        on player right clicks block location_flagged:dd_entrance_otherblock:
        - ratelimit <player> 1t
        - if <player.item_in_hand> matches dd_DungeonentranceEditor:
            - stop

        - define mainblock <context.location.flag[dd_entrance_otherblock]>
        - define data <[mainblock].flag[dd_entrance]>
        - run dd_EnterDungeon def.dungeonKey:<[data.dungeon_key]> def.exitLocation:<[data.exit_location].if_null[<player.location>]>

        #Exit dungeon
        on player enters area_flagged:dd_exitArea:
        - ratelimit <player> 10t
        #Skip if in spectator mode
        - if <player.gamemode> == spectator:
            - stop
        - run dd_ExitDungeon

        #Fire custom events for players leaving/entering dungeon worlds
        on player dies in:world_flagged:dd_DungeonSettings:
        - define context <map[location=<player.location>;reason=PLAYER_DIES]>
        - customevent id:dd_player_exits_dungeon context:<[context]>

        on player resurrected in:world_flagged:dd_DungeonSettings:
        - define context <map[location=<player.location>;reason=PLAYER_RESURRECTED]>
        - customevent id:dd_player_enters_dungeon context:<[context]>

        on player respawns:
        - if !<context.location.world.has_flag[dd_DungeonSettings]>:
            - stop
        - define context <map[location=<context.location>;reason=PLAYER_RESPAWNS]>
        - customevent id:dd_player_enters_dungeon context:<[context]>

        on player teleports:
        #Skip if not changing worlds
        - if <context.origin.world> matches <context.destination.world>:
            - stop

        #Fire event for leaving dungeon
        - if <context.origin.world.has_flag[dd_DungeonSettings]>:
            - define context <map[location=<context.origin>;reason=PLAYER_TELEPORTS]>
            - customevent id:dd_player_exits_dungeon context:<[context]>

        #Fire event for entering dungeon
        - if <context.destination.world.has_flag[dd_DungeonSettings]>:
            - define context <map[location=<context.destination>;reason=PLAYER_TELEPORTS]>
            - customevent id:dd_player_enters_dungeon context:<[context]>


        #Apply/Remove Player Attributes when they enter/leave dungeon worlds
        on custom event id:dd_player_exits_dungeon:
        - ratelimit <player> 1t
        - define dungeonWorld <context.location.world>
        - define dungeonAttributes <[dungeonWorld].flag[dd_dungeonsettings.player_attributes].if_null[<map[]>]>
        - define attributeUuids <list[]>

        - foreach <[dungeonAttributes]> as:attributeData key:attributeKey:
            - foreach <[attributeData]> as:attribute:
                - define attributeUuids:->:<[attribute.id]>

        - if !<[attributeUuids].is_empty>:
            - adjust <player> remove_attribute_modifiers:<[attributeUuids]>

        on custom event id:dd_player_enters_dungeon:
        - ratelimit <player> 1t
        - define dungeonWorld <context.location.world>
        - define dungeonAttributes <[dungeonWorld].flag[dd_dungeonsettings.player_attributes].if_null[null]>

        - if <[dungeonAttributes]> != null:
            - adjust <player> add_attribute_modifiers:<[dungeonAttributes]>