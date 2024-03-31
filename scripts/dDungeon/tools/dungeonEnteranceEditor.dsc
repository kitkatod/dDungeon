dd_DungeonentranceEditor:
    debug: false
    type: item
    display name: <gold><italic>Dungeon Entrance Editor
    material: oak_trapdoor
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <reset><green>Use <gold><&keybind[key.use]> <green>to change settings for a dDungeon Entrance/Exit.<n>This is used <underline>outside<reset><green> an existing dungeon, not on dungeon Sections/Schematics.
    - <reset><green>Press <gold><&keybind[key.swapOffhand]> <green>to swap to Spawner Editor
    flags:
        dd_show_DungeonEntranceBlock: true
        dd_toolswap_nexttool: dd_SpawnerEditor
        dd_toolswap_previoustool: dd_FakeBlockMarker

dd_DungeonEntranceEditor_Events:
    debug: false
    type: world
    events:
        on player right clicks block with:dd_DungeonEntranceEditor:
        - determine cancelled passively
        - ratelimit <player> 10t

        #"trace" blocks the player is looking towards to a certain distance. If they're looking towards an existing options block then select that.
        #Used to look "through" solid blocks
        - foreach <player.eye_location.facing_blocks[20]> as:block:
            - if <[block].has_flag[dd_entrance]>:
                - run dd_DungeonEntranceEditor_MainMenu def.loc:<[block]>
                - stop

        #Find the clicked block from ray trace
        - define loc <player.eye_location.ray_trace[return=block;range=25;nonsolids=true].block.if_null[no_value]>
        - if <[loc]> == no_value:
            - stop
        - run dd_DungeonEntranceEditor_MainMenu def.loc:<[loc]>


dd_DungeonEntranceEditor_MainMenu:
    debug: false
    type: task
    data:
        hint_AddNewEntrance: <italic><green>A new Dungeon Entrance will be created on the selected block.
        hint_CancelNewEntrance: <italic><gold>Cancels location selection.<n>Will not create a new entrance.

        hint_SetDungeonKey: <italic><gold>Change the DungeonKey this Entrance should use.<n>This will connect the Entrance to the dungeon with a given Dungeonkey.
        hint_SetExit: <italic><gold>Change the Exit Location.<n>This will be where players are teleported to when leaving the dungeon.<n>Location will be where you are currently standing. Includes your Pitch/Yaw.
        hint_DeleteEntrance: <italic><red>The selected Dungeon Entrance will be deleted.<n>Note - this does not delete the Dungeon it is associated to.
    definitions: loc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - if <[loc].has_flag[dd_entrance]>:
        #Options for existing entrance
        - define entranceData <[loc].flag[dd_entrance]>
        - narrate "<n><blue><italic> *** Click to modify this Entrance's settings."

        - clickable dd_DungeonEntranceEditor_SetDungeonKey def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetDungeonKey
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetDungeonKey].id>
        - narrate "<blue>1: Change Dungeon Key (<[entranceData.dungeon_key].if_null[ERROR]>) <gold>[<element[SET].on_click[<entry[clickSetDungeonKey].command>].on_hover[<script.data_key[data.hint_SetDungeonKey].parsed>]>]"

        - clickable dd_DungeonEntranceEditor_SetExitLocation def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetExit
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetExit].id>
        - narrate "<blue>2: Change Exit Location <gold>[<element[SET].on_click[<entry[clickSetExit].command>].on_hover[<script.data_key[data.hint_SetExit].parsed>]>]"

        - narrate " "

        - clickable dd_DungeonEntranceEditor_DeleteEntrance def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickDelete
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDelete].id>
        - narrate "<blue>*: Delete this Entrance <red>[<element[DELETE].on_click[<entry[clickDelete].command>].on_hover[<script.data_key[data.hint_DeleteEntrance].parsed>]>]"

    - else:
        #Option to create a new entrance
        - narrate "<n><blue><italic> *** An entrance doesn't exist on the selected location. Click to add one, or cancel."

        - clickable dd_DungeonEntranceEditor_CreateNewEntrance def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCreateNew
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCreateNew].id>
        - narrate "<blue>1: <gold>[<element[ADD NEW ENTRANCE].on_click[<entry[clickCreateNew].command>].on_hover[<script.data_key[data.hint_AddNewEntrance].parsed>]>]"

        - clickable dd_DungeonEntranceEditor_MainMenu_Cancel def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCancel
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
        - narrate "<blue>2: <red>[<element[CANCEL].on_click[<entry[clickCancel].command>].on_hover[<script.data_key[data.hint_CancelNewEntrance].parsed>]>]"


dd_DungeonEntranceEditor_MainMenu_Cancel:
    debug: false
    type: task
    definitions: clickableGroupId
    script:
    - narrate "<blue><italic> *** Cancelled<n>"
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
