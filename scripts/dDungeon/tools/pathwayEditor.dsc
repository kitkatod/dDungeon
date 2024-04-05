dd_PathwayEditor:
    debug: false
    type: item
    display name: <gold><italic>Dungeon Pathway Wand
    material: oak_door
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <reset><green>Use <gold><&keybind[key.use]> <green> on a block to mark a new Section Pathway, or edit an existing Pathway
    - <reset><green>Press <gold><&keybind[key.swapOffhand]> <green>to swap to Inventory Editor
    flags:
        dd_show_sectionOptions: true
        dd_show_pathways: true
        dd_toolswap_nexttool: dd_InventoryEditor
        dd_toolswap_previoustool: dd_SpawnerEditor


dd_PathwayEditor_Events:
    debug: false
    type: world
    events:
        on player right clicks block with:dd_PathwayEditor:
        - determine cancelled passively
        - if !<player.has_flag[dd_SchematicEditor_selectedOptionsLocation]>:
            - narrate "<red><italic> *** Place select an Options Block with the Schematic Wand first."
            - stop

        #Get selected options block data
        - define optionsLoc <player.flag[dd_SchematicEditor_selectedOptionsLocation]>
        - define optionsData <[optionsLoc].flag[dd_SectionOptions]>

        #"trace" blocks the player is looking towards to a certain distance. If they're looking towards an existing pathway block then select that.
        #Used to look "through" solid blocks
        - foreach <player.eye_location.facing_blocks[50]> as:block:
            - define relativeLocKey <[block].sub[<[optionsLoc]>].proc[dd_locationtokey]>
            - if <[optionsData.pathways].contains[<[relativeLocKey]>]>:
                - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLocKey]> def.optionsLoc:<[optionsLoc]>
                - stop

        #Find the clicked block from ray trace
        - define clickedLoc <player.eye_location.ray_trace[return=block;range=25].block.if_null[no_value]>
        - if <[clickedLoc]> == no_value:
            - stop
        - define relativeLocKey <[clickedLoc].round.sub[<[optionsLoc]>].proc[dd_locationtokey]>
        - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLocKey]> def.optionsLoc:<[optionsLoc]>


dd_PathwayEditor_MainMenu:
    debug: false
    type: task
    data:
        hint_AddNewPathway: <italic>A new Pathway Connection will be created on the currently select block, for the current Section.<n>You'll be prompted for initial settings.
        hint_CancelNewPathway: <italic>Cancel creating a new Pathway Connection.
        hint_AddNextRoomType: <italic>Add a Section Type for Dungeon Generation to pick from.<n>Will be used to determine the 'Next' non-hallway section off this Pathway.<n>If Dungeon Generation is placing a hallway, this setting will be remembered until it places a non-hallway.<n>Can be left empty, and it won't modify the 'Next' section type.
        hint_RemoveNextRoomType: <italic>Remove this Section Type from the list of Next Section Types
        hint_HallwayType: <italic>Set what type of Hallway should be used when connecting to this Pathway.<n>Can optionally set this to SKIP_HALLWAY to not place any hallways from this Pathway onward in Dungeon Generation.
        hint_ResetHallwayCountEnable: <italic>Force Dungeon Generation to re-roll a Hallway Count starting from this Pathway.<n>For example, if no more Hallways would have been placed,<n>this could make a new set of Hallways appear after the Pathway.
        hint_ResetHallwayCountDisabled: <italic>Do not re-roll a new Hallway Count.
        hint_AllowIncoming: <italic>Disable to disallow existing sections to connect onto this pathway.<n>Do not disable this if it is the only pathway on the section, otherwise the section will never be placed.
        hint_PrintData: <italic>Show data for this Pathway in chat.
        hint_Delete: <italic>Delete this Pathway Connection and any settings associated to it.<n>This does not delete the Section overall.
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - if <[optionsData.pathways].contains[<[relativeLoc]>]>:
        #Options for existing pathway
        - narrate "<n><blue><italic> *** Click to modify this pathway's settings."

        - clickable dd_PathwayEditor_PromptAddConnectingType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickAddConType
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAddConType].id>
        - narrate "<blue>1: Next Section Types"
        - narrate "<blue>  ** <gold>[<element[ADD A NEXT SECTION TYPE].on_click[<entry[clickAddConType].command>].on_hover[<script.data_key[data.hint_AddNextRoomType].parsed>]>]"

        #List configured "Next Room Types, with chances"
        - define nextRoomTypes <[optionsData.pathways.<[relativeLoc]>.possible_connections]>
        - foreach <[nextRoomTypes]> as:nextRoomData key:nextRoomType:
            - clickable dd_PathwayEditor_PromptRemoveConnectingType_Confirm def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[nextRoomType]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickRemoveType
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAddConType].id>

            - narrate "<blue>  ** <red><element[(-)].on_click[<entry[clickRemoveType].command>].on_hover[<script.data_key[data.hint_RemoveNextRoomType].parsed>]> <blue><[nextRoomType]> (Chance: <[nextRoomData.chance]>)"

        - narrate " "

        - clickable dd_PathwayEditor_PromptEditHallwayType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickEditHallwayType
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickEditHallwayType].id>
        - define hallwayType <[optionsData.pathways.<[relativeLoc]>.hallwayType].if_null[default]>
        - narrate "<blue>2: Hallway Type (<[hallwayType]>) <gold>[<element[EDIT].on_click[<entry[clickEditHallwayType].command>].on_hover[<script.data_key[data.hint_HallwayType].parsed>]>]"

        - clickable dd_PathwayEditor_EditResetHallwayCount def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.value:true usages:1 for:<player> until:5m save:clickEnableResetHallwayCount
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickEnableResetHallwayCount].id>
        - clickable dd_PathwayEditor_EditResetHallwayCount def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> def.value:false usages:1 for:<player> until:5m save:clickDisableResetHallwayCount
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDisableResetHallwayCount].id>
        - define resetHallwayCount <[optionsData.pathways.<[relativeLoc]>.resetHallwayCount].if_null[false]>
        - narrate "<blue>3: Reset Hallway Count (<[resetHallwayCount]>) <gold>[<element[ENABLE].on_click[<entry[clickEnableResetHallwayCount].command>].on_hover[<script.data_key[data.hint_ResetHallwayCountEnable].parsed>]>] <reset><blue>| <gold>[<element[DISABLE].on_click[<entry[clickDisableResetHallwayCount].command>].on_hover[<script.data_key[data.hint_ResetHallwayCountDisabled].parsed>]>]"

        - clickable dd_PathwayEditor_ToggleAllowIncoming def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickEditAllowIncoming
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickEditAllowIncoming].id>
        - define allowIncoming <[optionsData.pathways.<[relativeLoc]>.allowIncoming].if_null[true]>
        - narrate "<blue>4: Allow Incoming (<[allowIncoming]>) <gold>[<element[TOGGLE].on_click[<entry[clickEditAllowIncoming].command>].on_hover[<script.data_key[data.hint_AllowIncoming].parsed>]>]"

        - clickable dd_PathwayEditor_PrintData def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickPrintData
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickPrintData].id>
        - narrate "<blue>5: Display Pathway Data <gold>[<element[SHOW].on_click[<entry[clickPrintData].command>].on_hover[<script.data_key[data.hint_PrintData].parsed>]>]"

        - narrate " "

        - clickable dd_PathwayEditor_DeletePath def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickDelete
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDelete].id>
        - narrate "<blue>9: <red>[<element[DELETE].on_click[<entry[clickDelete].command>].on_hover[<script.data_key[data.hint_Delete].parsed>]>]"

    - else:
        #Option to create a new pathway
        - narrate "<n><blue><italic> *** A pathway doesn't exist on the selected location. Click to add one, or cancel."
        - clickable dd_PathwayEditor_AddPath def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickAddPath
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAddPath].id>
        - narrate "<blue>1: <gold>[<element[ADD NEW PATHWAY].on_click[<entry[clickAddPath].command>].on_hover[<script.data_key[data.hint_AddNewPathway].parsed>]>]"
        - clickable dd_PathwayEditor_MainMenu_Cancel def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCancel
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
        - narrate "<blue>2: <red>[<element[CANCEL].on_click[<entry[clickCancel].command>].on_hover[<script.data_key[data.hint_CancelNewPathway].parsed>]>]"



dd_PathwayEditor_MainMenu_Cancel:
    debug: false
    type: task
    definitions: clickableGroupId
    script:
    - narrate "<blue><italic> *** Cancelled<n>"
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
