dd_SchematicEditor:
    debug: false
    type: item
    display name: <gold><italic>Dungeon Schematic Wand
    material: blaze_rod
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <reset><green>Use <gold><&keybind[key.use]> <green>to mark a new Dungeon Section, or edit an existing Section
    - <reset><green>Press <gold><&keybind[key.swapOffhand]> <green>to swap to Inventory Editor
    flags:
        dd_show_sectionOptions: true
        dd_toolswap_nexttool: dd_PathwayEditor
        dd_toolswap_previoustool: dd_SpawnerEditor

dd_SchematicEditor_Events:
    debug: false
    type: world
    events:
        on player right clicks block with:dd_SchematicEditor:
        - determine cancelled passively
        #"trace" blocks the player is looking towards to a certain distance. If they're looking towards an existing options block then select that.
        #Used to look "through" solid blocks
        - foreach <player.eye_location.facing_blocks[50]> as:block:
            - if <[block].has_flag[dd_SectionOptions]>:
                - run dd_SchematicEditor_MainMenu def.optionsLoc:<[block]>
                - stop

        #Find the clicked block from ray trace
        - define loc <player.eye_location.ray_trace[return=block;range=25].block.if_null[no_value]>
        - if <[loc]> == no_value:
            - stop
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[loc]>

dd_SchematicEditor_MainMenu:
    debug: false
    type: task
    data:
        hint_SetNewOptions: <italic>Mark clicked block as a new Schematic.<n> You'll be prompted for a Name, Category, and Type.
        hint_CancelNewOptions: <italic>Cancel selecting this block.
        hint_UpdateAreaWorldEdit: <italic>Update Section's area to match your current World Edit selection.
        hint_UpdateAreaAuto: <italic>Update Section's area automatically. <n>Area will start at the Section Origin (where the options block is) and<n>repeatedly expand until it reaches only air.
        hint_ShowSectionBoundary: <italic>Outline this Section's area with red sparks for a few seconds
        hint_ChangeCategory: <italic>Change what Dungeon Category this Section should be saved in
        hint_ChangeType: <italic>Change what Section Type this Section is
        hint_SetEntrance: <italic>Set where the dungeon will place new players entering the dungeon.<n>If this is not set for a spawn_room type, the player will be placed at the section's origin point (where the options block is).
        hint_SetExitRadius: <italic>Set Radius around Entrance that will be setup as a Dungeon Exit.<n>Players entering this area will be teleported out of the dungeon.<n>Where player is teleported to is dependent on how they entered the dungeon.
        hint_ChangeName: <italic>Change the name of this Schematic.<n>Note, Schematic names of the same Category+Type with a different _# suffix will be grouped during Dungeon Generation.<n>For example, foobar_1 and foobar_2 will be grouped, and a random one selected during Dungeon Generation.
        hint_SetChance: <italic>Change the Chance value of this Schematic being placed during Dungeon Generation.<n>This is the weighted chance this Section will be placed when this Type of section is attempting to be placed.<n>If this Section has multiple variants (name ends in _#), only the variant _1 will be used for checking chance. (See Change Name option for details)
        hint_SetMaxOccurrenceCount: <italic>Change the Maximum number of times this section may appear within a single dungeon.
        hint_Save: <italic>Save this Section as a Schematic to disk.<n>This will make the Section usable in Dungeon Generation.
        hint_Delete: <italic>Delete the data saved to the current Section Options block.<n>This does not automatically delete files from disk if the Section was saved previously.<n>You'll have the option to delete files also as a second step.
        hint_DisplayData: <italic>Print in chat all data saved for the current section.<n>Will attempt to be formatted to be easily read.
        hint_Exit: <italic>Exit Schematic Editor Menu
    definitions: optionsLoc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - if <player.flag[dd_SchematicEditor_selectedOptionsLocation].if_null[]> != <[optionsLoc]>:
        - flag <player> dd_SchematicEditor_selectedOptionsLocation:<[optionsLoc]>
        - narrate "<blue><italic> *** New Schematic Location Set"
        - run dd_ShowSectionBlocks_Player def.user:<player>

    #Location doesn't have section options set yet. Prompt to create one
    - if !<[optionsLoc].has_flag[dd_SectionOptions]>:
        - narrate "<blue><italic> *** Location isn't setup with Schematic Data yet. Create new section or cancel."
        - clickable dd_SchematicEditor_SetupNewOptionsBlock def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickCreateNew
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCreateNew].id>
        - clickable dd_SchematicEditor_MainMenu_Cancel def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickCancel
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
        - narrate "<blue> * <gold>[<element[CREATE NEW].on_click[<entry[clickCreateNew].command>].on_hover[<script.data_key[data.hint_SetNewOptions].parsed>]>] <blue>| <red>[<element[CANCEL].on_click[<entry[clickCancel].command>].on_hover[<script.data_key[data.hint_CancelNewOptions].parsed>]>]"

    #Location has section options, show menu
    - else:
        - narrate " "

        - define sectionData <[optionsLoc].flag[dd_SectionOptions]>

        - clickable dd_SchematicEditor_UpdateAreaFromWorldEdit def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickUpdateAreaFromWorldEdit
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickUpdateAreaFromWorldEdit].id>
        - clickable dd_SchematicEditor_AutoSetSectionArea def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.returnToMainMenu:true for:<player> usages:1 until:5m save:clickAutoSetArea
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAutoSetArea].id>
        - define text "<blue>1: Update Section Area "
        #If WorldEdit is installed, show an option to use the selection from it
        - if <plugin[WorldEdit].if_null[NOT_INSTALLED]> != NOT_INSTALLED && <plugin[Depenizen].if_null[NOT_INSTALLED]> != NOT_INSTALLED:
            - define text "<[text]><gold>[<element[APPLY FROM WORLD EDIT].on_click[<entry[clickUpdateAreaFromWorldEdit].command>].on_hover[<script.data_key[data.hint_UpdateAreaWorldEdit].parsed>]>] <blue>| "
        - define text <[text]><gold>[<element[AUTO SET].on_click[<entry[clickAutoSetArea].command>].on_hover[<script.data_key[data.hint_UpdateAreaAuto].parsed>]>]
        - narrate <[text]>

        - clickable dd_SchematicEditor_ShowBoundary def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.returnToMainMenu:true for:<player> usages:1 until:5m save:clickShowBoundary
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickShowBoundary].id>
        - narrate "<blue>2: Show Section Boundary <gold>[<element[SHOW].on_click[<entry[clickShowBoundary].command>].on_hover[<script.data_key[data.hint_ShowSectionBoundary].parsed>]>]"

        - clickable dd_SchematicEditor_SetCategory def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.returnToMainMenu:true for:<player> usages:1 until:5m save:clickSetCategory
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetCategory].id>
        - narrate "<blue>3: Change Dungeon Category (Current: <[sectionData.category].if_null[ERROR]>) <gold>[<element[EDIT].on_click[<entry[clickSetCategory].command>].on_hover[<script.data_key[data.hint_ChangeCategory].parsed>]>]"

        - clickable dd_SchematicEditor_SetType def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.returnToMainMenu:true for:<player> usages:1 until:5m save:clickSetType
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetType].id>
        - narrate "<blue>4: Change Section Type (Current: <[sectionData.type].if_null[ERROR]>) <gold>[<element[EDIT].on_click[<entry[clickSetType].command>].on_hover[<script.data_key[data.hint_ChangeType].parsed>]>]"

        - if <[sectionData.type].if_null[null]> == spawn_room:
            - clickable dd_SchematicEditor_SetDungeonEntrance def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickSetEntrance
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetEntrance].id>
            - narrate "<blue>4.1: Set Spawn Room's Entrance Location <gold>[<element[EDIT].on_click[<entry[clickSetEntrance].command>].on_hover[<script.data_key[data.hint_SetEntrance].parsed>]>]"

            - clickable dd_SchematicEditor_SetDungeonExitRadius def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickSetExitRadius
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetExitRadius].id>
            - narrate "<blue>4.2: Set Spawn Room's Exit Radius (Current: <[sectionData.exitRadius].if_null[ERROR]>) <gold>[<element[SET].on_click[<entry[clickSetExitRadius].command>].on_hover[<script.data_key[data.hint_SetExitRadius].parsed>]>]"

        - clickable dd_SchematicEditor_SetSchematicName def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.returnToMainMenu:true for:<player> usages:1 until:5m save:clickSetName
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetName].id>
        - narrate "<blue>5: Change Name (Current: <[sectionData.name].if_null[ERROR]>) <gold>[<element[EDIT].on_click[<entry[clickSetName].command>].on_hover[<script.data_key[data.hint_ChangeName].parsed>]>]"

        - clickable dd_SchematicEditor_SetChance def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickSetChance
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetChance].id>
        - narrate "<blue>6: Change Chance (Current: <[sectionData.chance].if_null[ERROR]>) <gold>[<element[EDIT].on_click[<entry[clickSetChance].command>].on_hover[<script.data_key[data.hint_SetChance].parsed>]>]"

        - clickable dd_SchematicEditor_SetMaxOccurrence def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickSetMaxOccurrence
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSetMaxOccurrence].id>
        - narrate "<blue>7: Change Max Per Dungeon (Current: <[sectionData.maxOccurrenceCount].if_null[-1]>) <gold>[<element[EDIT].on_click[<entry[clickSetMaxOccurrence].command>].on_hover[<script.data_key[data.hint_SetMaxOccurrenceCount].parsed>]>]"



        - clickable dd_SchematicEditor_SaveSchematic def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickSave
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickSave].id>
        - narrate "<blue>8: Save Section <green>[<element[SAVE].on_click[<entry[clickSave].command>].on_hover[<script.data_key[data.hint_Save].parsed>]>]"

        - clickable dd_SchematicEditor_PromptDeleteData def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickDeleteData
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDeleteData].id>
        - narrate "<blue>9: Delete Section <red><underline>[<element[DELETE].on_click[<entry[clickDeleteData].command>].on_hover[<script.data_key[data.hint_Delete].parsed>]>]"

        - clickable dd_SchematicEditor_PrintOptionsData def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickPrintOptionsData
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickPrintOptionsData].id>
        - narrate "<blue>10: Display Section Data <gold>[<element[SHOW].on_click[<entry[clickPrintOptionsData].command>].on_hover[<script.data_key[data.hint_DisplayData].parsed>]>]"

        - clickable dd_SchematicEditor_MainMenu_Cancel def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:5m save:clickExit
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickExit].id>
        - narrate "<blue>00: [<element[EXIT MENU].on_click[<entry[clickExit].command>].on_hover[<script.data_key[data.hint_Exit].parsed>]>]"



dd_SchematicEditor_MainMenu_Cancel:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - narrate "<blue><italic> *** Exited Schematic Editor<n>"



dd_SchematicCreator_setProperty:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId|settingName|value|returnToMainMenu
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[optionsLoc]> dd_SectionOptions.<[settingName]>:<[value]>
    - narrate "<blue><italic> *** <[settingName]> <reset><blue>: <gold><[value]><n>"

    - if <[returnToMainMenu].if_null[false]>:
        - wait 10t
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>
