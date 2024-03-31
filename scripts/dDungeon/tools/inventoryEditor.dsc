dd_InventoryEditor:
    debug: false
    type: item
    display name: <gold><italic>Dungeon Inventory Wand
    material: chest
    enchantments:
    - vanishing_curse:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <reset><green>Use <gold><&keybind[key.use]> <green>to set Inventory Loot settings on a chest, or edit existing settings for a chest
    - <reset><green>Press <gold><&keybind[key.swapOffhand]> <green>to swap to Fake Block Marker
    flags:
        dd_show_sectionOptions: true
        dd_show_inventories: true
        dd_toolswap_nexttool: dd_FakeBlockMarker
        dd_toolswap_previoustool: dd_PathwayEditor


dd_InventoryEditor_Events:
    debug: false
    type: world
    events:
        on player right clicks block with:dd_InventoryEditor:
        - determine cancelled passively
        - ratelimit <player> 1t
        - if !<player.has_flag[dd_SchematicEditor_selectedOptionsLocation]>:
            - narrate "<red><italic> *** Please select an Options Block with the Schematic Wand first."
            - stop

        #Get selected options block data
        - define optionsLoc <player.flag[dd_SchematicEditor_selectedOptionsLocation]>
        - define optionsData <[optionsLoc].flag[dd_SectionOptions]>

        #"trace" blocks the player is looking towards to a certain distance. If they're looking towards an existing pathway block then select that.
        #Used to look "through" solid blocks
        - foreach <player.eye_location.facing_blocks[50]> as:block:
            - define relativeLocKey <[block].sub[<[optionsLoc]>].proc[dd_locationtokey]>
            - if <[optionsData.inventories].contains[<[relativeLocKey]>]>:
                - run dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLocKey]> def.optionsLoc:<[optionsLoc]>
                - stop

        #Find the clicked block from ray trace
        - define clickedLoc <player.eye_location.ray_trace[return=block;range=25].block.if_null[no_value]>
        - if <[clickedLoc]> == no_value:
            - stop
        - if !<[clickedLoc].has_inventory>:
            - stop

        - define relativeLocKey <[clickedLoc].sub[<[optionsLoc]>].proc[dd_locationtokey]>

        #If this block isn't configured and there's another block, check if that one is configured
        - if !<[optionsData.inventories].contains[<[relativeLocKey]>]> && <[clickedLoc].other_block.if_null[_empty_]> != _empty_:
            - define tmpRelativeLoc <[clickedLoc].other_block.sub[<[optionsLoc]>].proc[dd_locationtokey]>
            - if <[optionsData.inventories].contains[<[tmpRelativeLoc]>]>:
                - define relativeLocKey <[tmpRelativeLoc].proc[dd_locationtokey]>

        - run dd_InventoryEditor_MainMenu def.relativeLoc:<[relativeLocKey]> def.optionsLoc:<[optionsLoc]>
        - determine cancelled



dd_InventoryEditor_MainMenu:
    debug: false
    type: task
    data:
        hint_AddNewInventory: Add a new inventory to this section at this location
        hint_CancelNewInventory: Cancle adding new Inventory

        hint_AddCategoryGroup: Add a new group of categories to choose from.<n>Only one category will be selected from each Category Group.
        hint_RemoveCategoryGroup: Remove this Category Group
        hint_EditCategoryGroup: Modify this Category Group
        hint_CopyInventorySettings: Copy settings for this inventory so they can be pasted to another inventory
        hint_PasteInventorySettings: Paste settings copied from another inventory to this one
        hint_Delete: Delete this Inventory from the Section
        hint_Exit: Exit Inventory Menu
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:5m

    - if !<[optionsData.inventories].contains[<[relativeLoc]>]> && <[optionsData.inventories].contains[<[relativeLoc].other_block.if_null[_empty_]>]>:
        - define relativeLoc <[relativeLoc].other_block>

    - if <[optionsData.inventories].contains[<[relativeLoc]>]>:
        #Show prompt
        - narrate "<n><blue><italic> *** Click to make changes to this inventory."

        #Show Add Group option
        - clickable dd_InventoryEditor_AddNewGroup def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickAddGroup
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAddGroup].id>
        - narrate "<blue> * <green>[<element[CREATE NEW GROUP].on_click[<entry[clickAddGroup].command>].on_hover[<script.data_key[data.hint_AddCategoryGroup]>]>]"

        #Show options for each existing inventory group
        - foreach <[optionsData.inventories.<[relativeLoc]>]> as:groupData key:groupId:
            - clickable dd_InventoryEditor_CategoryGroupMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickEditGroup
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickEditGroup].id>
            - clickable dd_InventoryEditor_RemoveInventoryGroup_Prompt def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.groupId:<[groupId]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickRemoveGroup
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickRemoveGroup].id>
            - narrate "<blue> * <[loop_index]>: <gold>[<element[MODIFY].on_click[<entry[clickEditGroup].command>].on_hover[<script.data_key[data.hint_EditCategoryGroup]>]>] <blue>| <red>[<element[DELETE].on_click[<entry[clickRemoveGroup].command>].on_hover[<script.data_key[data.hint_RemoveCategoryGroup]>]>]"

        - narrate " "

        - clickable dd_InventoryEditor_CopySettings def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCopy
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCopy].id>
        - narrate "<blue> * <gold>[<element[COPY SETTINGS].on_click[<entry[clickCopy].command>].on_hover[<script.data_key[data.hint_CopyInventorySettings].parsed>]>]"

        - if <player.has_flag[dd_InventoryEditor_CopiedSettings]>:
            - clickable dd_InventoryEditor_PasteSettings def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickPaste
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickPaste].id>
            - narrate "<blue> * <gold>[<element[PASTE SETTINGS].on_click[<entry[clickPaste].command>].on_hover[<script.data_key[data.hint_PasteInventorySettings].parsed>]>]"

        - narrate " "

        - clickable dd_InventoryEditor_DeleteInventory_Prompt def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickDelete
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDelete].id>
        - narrate "<blue> * <red>[<element[DELETE INVENTORY].on_click[<entry[clickDelete].command>].on_hover[<script.data_key[data.hint_Delete].parsed>]>]"

        - clickable dd_InventoryEditor_MainMenu_Cancel def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickExit
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickExit].id>
        - narrate "<blue> * <gold>[<element[EXIT MENU].on_click[<entry[clickExit].command>].on_hover[<script.data_key[data.hint_Exit].parsed>]>]"

    - else:
        #Option to create a new inventory
        - narrate "<n><blue><italic> *** An inventory doesn't exist at the selected location. Click to add one, or cancel."

        - if <player.has_flag[dd_InventoryEditor_CopiedSettings]>:
            - clickable dd_InventoryEditor_PasteSettings def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickPaste
            - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickPaste].id>
            - narrate "<blue> * <gold>[<element[PASTE SETTINGS].on_click[<entry[clickPaste].command>].on_hover[<script.data_key[data.hint_PasteInventorySettings].parsed>]>]"

        - clickable dd_InventoryEditor_AddNewInventory def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickAddInventory
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickAddInventory].id>
        - narrate "<blue> * <gold>[<element[ADD NEW INVENTORY].on_click[<entry[clickAddInventory].command>].on_hover[<script.data_key[data.hint_AddNewInventory].parsed>]>]"
        - clickable dd_InventoryEditor_MainMenu_Cancel def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:5m save:clickCancel
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
        - narrate "<blue> * <red>[<element[CANCEL].on_click[<entry[clickCancel].command>].on_hover[<script.data_key[data.hint_CancelNewInventory].parsed>]>]"

dd_InventoryEditor_MainMenu_Cancel:
    debug: false
    type: task
    definitions: clickableGroupId
    script:
    - narrate "<blue><italic> *** Cancelled<n>"
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>