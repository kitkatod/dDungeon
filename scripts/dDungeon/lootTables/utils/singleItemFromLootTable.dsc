dd_LootTables_SingleItemFromLootTable:
    debug: false
    type: procedure
    definitions: lootTableName
    script:
    - define lootTableReturn <[lootTableName].proc[dd_RollLootTable_Category]>
    - if !<[lootTableReturn].is_empty>:
        - determine <[lootTableReturn].first>
    - else:
        - determine null