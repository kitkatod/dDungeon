dd_ValidateConfigs:
    debug: false
    type: task
    data:
        dd_version: 1.2.0
    script:
    #Show version
    - narrate "<gold>[dDungeon] Running Validation. v<script.data_key[dd_version]>"

    #Validate items in Loot Tables
    - foreach <script[dd_LootTables].data_key[lootTables]> as:lootTableData key:lootTableName:
        - foreach <[lootTableData]> key:itemEntryKey as:itemEntryData:
            - if <[itemEntryKey].starts_with[_]>:
                - foreach next

            - define itemInput <[itemEntryKey].before_last[#]>

            #Skip this specific procedure on the check, as it just returns results from another loot table
            - if <[itemInput]> == dd_LootTables_SingleItemFromLootTable:
                - foreach next

            - define context <[itemEntryData.item_proc_args].if_null[null]>

            - define item <[itemInput].proc[dd_LootTables_ItemFromInput].context[<[context]>]>
            - if <[item]> == null || <[item].object_type> != item:
                - narrate "<red>[dDungeon] LootTable Configuration Error, invalid item input on LootTable <[lootTableName]>. Input: <[itemEntryKey]>" targets:<server.online_ops>

    #Get list of all Schematic files
    - define fileList <list[]>
    - foreach <util.list_files[schematics/dDungeon/]> as:category:
        - if <[category].starts_with[_]>:
            - foreach next

        - foreach <util.list_files[schematics/dDungeon/<[category]>/]> as:type:
            - if <[type].starts_with[_]>:
                - foreach next

            - foreach <proc[dd_GetFilesList].context[<[category]>|<[type]>]> as:file:
                - define fileList:->:<[file]>

    - define dataVersion <script[dd_Config].data_key[dd_schematic_data_version]>
    - define outOfDateSchematics 0

    #Validate schematic Section Options file configs
    - foreach <[fileList]> as:fileName:
        - ~yaml id:ddungeon_<queue.id> load:schematics/dDungeon/<[fileName]>.yml
        - define sectionOptions <yaml[ddungeon_<queue.id>].read[SectionOptions]>
        - ~yaml id:ddungeon_<queue.id> unload

        - if <[sectionOptions.schematic_data_version].if_null[1.0]> != <[dataVersion]>:
            - define outOfDateSchematics:++

        - if <[sectionOptions.pathways].if_null[<map[]>].is_empty>:
            - narrate "<red>[dDungeon] Config Error - Section has no pathways in (<[fileName]>)"

        - foreach <[sectionOptions.inventories].if_null[<map[]>]> as:invData:
            - foreach <[invData].if_null[<map[]>]> as:invGroupData:
                - foreach <[invGroupData].if_null[<map[]>]> as:chance key:lootTableName:
                    - if !<[lootTableName].proc[dd_LootTables_Exists]>:
                        - narrate "<red>[dDungeon] Schematic Section Configuration Error, Configured Loot Table not found (<[lootTableName]>) in (<[fileName]>)" targets:<server.online_ops>

    - if <[outOfDateSchematics]> > 0:
        - narrate "<red>[dDungeon] There are Schematic Data files out of date. Consider resaving schematics to update format."

    - narrate "<gold>[dDungeon] Validation Finished"