dd_LootTables_ValidateConfigs:
    debug: false
    type: task
    script:
    #Validate items in Loot Tables
    - foreach <script[dd_LootTables].data_key[lootTables]> as:lootTableData key:lootTableName:
        - foreach <[lootTableData].keys> as:itemEntryKey:
            - if <[itemEntryKey].starts_with[_]>:
                - foreach next

            - define itemInput <[itemEntryKey].before_last[#]>

            #Skip this specific procedure on the check, as it just returns results from another loot table
            - if <[itemInput]> == dd_LootTables_SingleItemFromLootTable:
                - foreach next

            - define item <[itemInput].proc[dd_LootTables_ItemFromInput]>
            - if <[item]> == null || <[item].object_type> != item:
                - narrate "<red>(dDungeon): LootTable Configuration Error, invalid item input on LootTable <[lootTableName]>. Input: <[itemEntryKey]>" targets:<server.online_ops>

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

    #Validate schematic Section Options file configs
    - foreach <[fileList]> as:fileName:
        - ~yaml id:tmp_template_options_yaml load:schematics/dDungeon/<[fileName]>.yml
        - define sectionOptions <yaml[tmp_template_options_yaml].read[SectionOptions]>
        - ~yaml id:tmp_template_options_yaml unload

        - foreach <[sectionOptions.inventories].if_null[<map[]>]> as:invData:
            - foreach <[invData].if_null[<map[]>]> as:invGroupData:
                - foreach <[invGroupData].if_null[<map[]>]> as:chance key:lootTableName:
                    - if !<[lootTableName].proc[dd_LootTables_Exists]>:
                        - narrate "<red>(dDungeon): Schematic Section Configuration Error, Configured Loot Table not found (<[lootTableName]>) in (<[fileName]>)" targets:<server.online_ops>