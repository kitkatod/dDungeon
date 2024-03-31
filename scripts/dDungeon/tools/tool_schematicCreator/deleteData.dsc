dd_SchematicEditor_PromptDeleteData:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - clickable dd_SchematicEditor_DeleteDataCancel def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:1m save:clickCancel
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
    - clickable dd_SchematicEditor_DeleteDataConfirm def.optionsLoc:<[optionsLoc]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:1m save:clickConfirm
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickConfirm].id>

    - narrate <n><blue>**********
    - narrate "<blue><italic> *** Section data is about to be deleted. This is not reversable."
    - narrate "<blue><italic> *** (Note: This will delete the data from the currently selected block. You'll have the option to delete files next if you confirm.)"
    #Slow the user down before deleting something....
    - wait 3s
    - narrate "<gold>[<element[CANCEL].on_click[<entry[clickCancel].command>]>] <blue>| <red><underline>[<element[CONFIRM DELETION].on_click[<entry[clickConfirm].command>]>]"
    - narrate <blue>**********<n>

dd_SchematicEditor_DeleteDataCancel:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Deletion Cancelled"

    - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>

dd_SchematicEditor_DeleteDataConfirm:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>
    - flag <[optionsLoc]> dd_SectionOptions:!
    - flag <player> dd_SchematicEditor_selectedOptionsLocation:!
    - narrate "<red><italic> *** Section Data Deleted"

    - define filePath /schematics/dDungeon/<[optionsData.category]>/<[optionsData.type]>/<[optionsData.name]>

    - if <util.has_file[<[filePath]>.yml]>:
        - define clickableGroupId <util.random_uuid>
        - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

        - clickable dd_SchematicEditor_DeleteFileCancel def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:1m save:clickCancel
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCancel].id>
        - clickable dd_SchematicEditor_DeleteFileConfirm def.filePath:<[filePath]> def.clickableGroupId:<[clickableGroupId]> for:<player> usages:1 until:1m save:clickDelete
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickDelete].id>

        - narrate <n><blue>**********
        - narrate "<blue><italic> *** Do you also want to delete the schematic files for this section?"
        - narrate "<blue><italic> *** (DO NOT DO THIS unless you are very sure)"
        #Slow the user down before deleting something....
        - wait 3s
        - narrate "<gold>[<element[CANCEL].on_click[<entry[clickCancel].command>]>] <blue>| <red><underline>[<element[DELETE FILES].on_click[<entry[clickDelete].command>]>]"
        - narrate <blue>**********<n>




dd_SchematicEditor_DeleteFileConfirm:
    debug: false
    type: task
    definitions: filePath|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define fileName <[filePath].after_last[/]>_<util.time_now.format[yyyyMMdd_HHmmss]>
    - define newPath /schematics/dDungeon/_deleted_history/<[fileName]>

    - ~filecopy origin:<[filePath]>.schem destination:<[newPath]>.schem
    - ~filecopy origin:<[filePath]>.yml destination:<[newPath]>.yml

    - adjust system delete_file:<[filePath]>.schem
    - adjust system delete_file:<[filePath]>.yml

    - narrate "<red><italic> *** Section Schematic/Data files Deleted"


dd_SchematicEditor_DeleteFileCancel:
    debug: false
    type: task
    definitions: clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Options block is deleted, schematic files have been kept"