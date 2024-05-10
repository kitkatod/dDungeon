dd_SpawnerEditor:
    debug: false
    type: item
    display name: <gold><italic>Spawn Point Tool
    material: spawner
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <reset><green>Use <gold><&keybind[key.use]> <green>to set Spawn Point settings at a location, or edit existing settings
    - <reset><green>Press <gold><&keybind[key.swapOffhand]> <green>to swap to Pathway Editor
    flags:
        dd_show_sectionOptions: true
        dd_show_spawners: true
        dd_toolswap_nexttool: dd_SchematicEditor
        dd_toolswap_previoustool: dd_DungeonEntranceEditor


dd_SpawnerEditor_Events:
    debug: false
    type: world
    events:
        on player right clicks block with:dd_SpawnerEditor:
        - determine cancelled passively
        - if !<player.has_flag[dd_SchematicEditor_selectedOptionsLocation]>:
            - narrate "<red><italic> *** Please select an Options Block with the Schematic Wand first."
            - stop

        #"trace" blocks the player is looking towards to a certain distance. If they're looking towards an existing options block then select that.
        #Used to look "through" solid blocks
        - foreach <player.eye_location.facing_blocks[20]> as:block:
            - if <[block].has_flag[dd_spawner]>:
                - run dd_SpawnerEditor_MainMenu def.loc:<[block]>
                - stop

        #Find the clicked block from ray trace
        - define loc <player.eye_location.ray_trace[return=block;range=25].block.if_null[no_value]>
        - if <[loc]> == no_value:
            - stop
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>


dd_SpawnerEditor_MainMenu:
    debug: false
    type: task
    data:
        hint_AddNewSpawner: <italic><green>A new Spawner will be created on the currently selected block.
        hint_CancelNewSpawner: <italic><gold>Cancels location selection.<n>Will not create a new spawner.

        hint_SetSpawnTable: <italic><gold>Change the Spawn Table used by this Spawn Point
        hint_SetSpawnerBank: <italic><gold>Change the Spawner's Bank value<n>This is used to determine the <underline>TOTAL <reset><italic><gold>number of Spawn Points this Spawner will ever spawn in the dungeon.<n>Once this value drops to zero, it will be deleted.
        hint_SetSpawnerBudgetPerSpawn: <italic><gold>Change the Spawner number of Spawn Points it may spawn each time it attempts to spawn mobs.<n><n>spawn spawn and more spawn....
        hint_SetSpawnerAreaMax: <italic><gold>Change the Spawner's area Spawn Point max.<n>If the Spawn Point sum for all mobs nearby is above this value, spawning will pause until it falls below this value again.
        hint_SetSpawnerRadius: <italic><gold>Change the Spawner's Spawn radius.<n>Controls area mobs will spawn within.<n>Also controls area which applies to 'Prevent Dungeon Spawning' setting (within 30 blocks of players max).
        hint_SetActivationRadius: <italic><gold>Change the Spawner's Activation radius.<n>Spawner will become active while any player is within this radius.<n>Set to -1 to make spawner always active if any player is in the world.
        hint_PreventGenericDungeonSpawning: <italic><gold>Prevent the Dungeon's Generic Spawning nearby this point.<n>This prevents normal generic mobs from utilizing all the Spawn Points available for the area.

        hint_SetBossbarEnable: <italic><gold>When enabled, players within the Bossbar Radius will be shown a Bossbar.<n>Bossbar's progress will be based on remaining Bank value in the Spawner.
        hint_SetBossbarRadius: <italic><gold>Show players within this radius of the Spawner a Bossbar
        hint_SetBossbarTitle: <italic><gold>Title of the Bossbar
        hint_SetBossbarColor: <italic><gold>Color of the filled section of the Bossbar
        hint_SetBossbarFog: <italic><gold>Enable/Disable showing Fog within the Spawner's Bossbar radius

        hint_DeleteSpawner: <italic><red>The selected Spawner will be deleted

        hint_CopySettings: <italic><gold>Copy settings from this Spawner.
        hint_PasteSettings: <italic><gold>Paste settings from another spawner to this one.
    definitions: loc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - if <[loc].has_flag[dd_spawner]>:
        #Options for existing Spawner
        - define spawnerData <[loc].flag[dd_spawner]>
        - narrate "<n><blue><italic> *** Click to modify this Spawner's settings."

        - clickable dd_SpawnerEditor_SetSpawnTable def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetSpawnTable
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetSpawnTable].id>
        - narrate "<blue>1: Set Spawn Table (<[spawnerData.spawn_table]>) <gold>[<element[SET].on_click[<entry[clickSetSpawnTable].command>].on_hover[<script.data_key[data.hint_SetSpawnTable].parsed>]>]"

        - clickable dd_SpawnerEditor_SetSpawnerBank def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetSpawnerBank
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetSpawnerBank].id>
        - narrate "<blue>2: Set Spawner's Bank (<[spawnerData.bank]>) <gold>[<element[SET].on_click[<entry[clickSetSpawnerBank].command>].on_hover[<script.data_key[data.hint_SetSpawnerBank].parsed>]>]"

        - clickable dd_SpawnerEditor_SetSpawnerBudget def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetSpawnerBudget
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetSpawnerBudget].id>
        - narrate "<blue>3: Set Spawner's Budget (<[spawnerData.budget]>) <gold>[<element[SET].on_click[<entry[clickSetSpawnerBudget].command>].on_hover[<script.data_key[data.hint_SetSpawnerBudgetPerSpawn].parsed>]>]"

        - clickable dd_SpawnerEditor_SetSpawnerAreaMax def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetSpawnerAreaMax
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetSpawnerAreaMax].id>
        - narrate "<blue>4: Set Spawner's Area Spawn Point Max (<[spawnerData.area_max]>) <gold>[<element[SET].on_click[<entry[clickSetSpawnerAreaMax].command>].on_hover[<script.data_key[data.hint_SetSpawnerAreaMax].parsed>]>]"

        - clickable dd_SpawnerEditor_SetSpawnRadius def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetSpawnerRadius
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetSpawnerRadius].id>
        - narrate "<blue>5: Set Spawn Radius (<[spawnerData.spawn_radius]>) <gold>[<element[SET].on_click[<entry[clickSetSpawnerRadius].command>].on_hover[<script.data_key[data.hint_SetSpawnerRadius].parsed>]>]"

        - clickable dd_SpawnerEditor_SetActivationRadius def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetActivationRadius
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetActivationRadius].id>
        - narrate "<blue>6: Set Activation Radius (<[spawnerData.activation_radius]>) <gold>[<element[SET].on_click[<entry[clickSetActivationRadius].command>].on_hover[<script.data_key[data.hint_SetActivationRadius].parsed>]>]"

        - clickable dd_SpawnerEditor_togglePreventDungeonSpawning def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickTogglePreventDungeonSpawning
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickTogglePreventDungeonSpawning].id>
        - narrate "<blue>7: Prevent Dungeon Spawning (<[spawnerData.prevent_dungeon_spawning_nearby]>) <gold>[<element[TOGGLE].on_click[<entry[clickTogglePreventDungeonSpawning].command>].on_hover[<script.data_key[data.hint_PreventGenericDungeonSpawning].parsed>]>]"

        - clickable dd_SpawnerEditor_ToggleBossbarEnabled def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickToggleBossbarEnabled
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickToggleBossbarEnabled].id>
        - narrate "<blue>8: Toggle Bossbar (<[spawnerData.bossbar_enabled].if_null[false]>) <gold>[<element[TOGGLE].on_click[<entry[clickToggleBossbarEnabled].command>].on_hover[<script.data_key[data.hint_SetBossbarEnable].parsed>]>]"

        - if <[spawnerData.bossbar_enabled].if_null[false]>:
            - clickable dd_SpawnerEditor_SetBossbarRadius def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetBossbarRadius
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetBossbarRadius].id>
            - narrate "<blue>8.1: Set Bossbar Radius (<[spawnerData.bossbar_radius].if_null[10]>) <gold>[<element[SET].on_click[<entry[clickSetBossbarRadius].command>].on_hover[<script.data_key[data.hint_SetBossbarRadius].parsed>]>]"

            - clickable dd_SpawnerEditor_SetBossbarTitle def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetBossbarTitle
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetBossbarTitle].id>
            - narrate "<blue>8.2: Set Bossbar Title (<[spawnerData.bossbar_title].if_null[Spawner Health]>) <gold>[<element[SET].on_click[<entry[clickSetBossbarTitle].command>].on_hover[<script.data_key[data.hint_SetBossbarTitle].parsed>]>]"

            - clickable dd_SpawnerEditor_SetBossbarColor def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickSetBossbarColor
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetBossbarColor].id>
            - narrate "<blue>8.3: Set Bossbar Color (<[spawnerData.bossbar_color].if_null[RED]>) <gold>[<element[SET].on_click[<entry[clickSetBossbarColor].command>].on_hover[<script.data_key[data.hint_SetBossbarColor].parsed>]>]"

            - clickable dd_SpawnerEditor_ToggleBossbarFog def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickToggleBossbarFog
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickToggleBossbarFog].id>
            - narrate "<blue>8.4: Toggle Bossbar Fog (<[spawnerData.bossbar_fog_enabled].if_null[true]>) <gold>[<element[TOGGLE].on_click[<entry[clickToggleBossbarFog].command>].on_hover[<script.data_key[data.hint_SetBossbarFog].parsed>]>]"

        - narrate " "

        - clickable dd_SpawnerEditor_Delete def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickDelete
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDelete].id>
        - narrate "<blue>9: <red>[<element[DELETE].on_click[<entry[clickDelete].command>].on_hover[<script.data_key[data.hint_DeleteSpawner].parsed>]>]"

        - clickable dd_SpawnerEditor_CopySettings def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCopy
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCopy].id>
        - narrate "<blue>**: Copy Spawner Settings <gold>[<element[COPY].on_click[<entry[clickCopy].command>].on_hover[<script.data_key[data.hint_CopySettings].parsed>]>]"

    - else:
        #Option to create a new spawner
        - narrate "<n><blue><italic> *** A spawner doesn't exist on the selected location. Click to add one, or cancel."
        - clickable dd_SpawnerEditor_CreateNew def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCreateNew
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCreateNew].id>
        - narrate "<blue>1: <gold>[<element[ADD NEW SPAWNER].on_click[<entry[clickCreateNew].command>].on_hover[<script.data_key[data.hint_AddNewSpawner].parsed>]>]"
        - clickable dd_PathwayEditor_MainMenu_Cancel def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCancel
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
        - narrate "<blue>2: <red>[<element[CANCEL].on_click[<entry[clickCancel].command>].on_hover[<script.data_key[data.hint_CancelNewSpawner].parsed>]>]"


    - if <player.has_flag[dd_SpawnerEditor_Settings]>:
        - clickable dd_SpawnerEditor_PasteSettings def.loc:<[loc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickPaste
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickPaste].id>
        - narrate "<blue>**: Paste Spawner Settings <gold>[<element[PASTE].on_click[<entry[clickPaste].command>].on_hover[<script.data_key[data.hint_PasteSettings].parsed>]>]"


dd_SpawnerEditor_MainMenu_Cancel:
    debug: false
    type: task
    definitions: clickableGroupId
    script:
    - narrate "<blue><italic> *** Cancelled<n>"
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>


