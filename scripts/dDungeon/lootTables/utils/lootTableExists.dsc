dd_LootTables_Exists:
    debug: false
    type: procedure
    definitions: lootTableName
    script:
    - determine <script[dd_LootTables].data_key[lootTables].keys.contains[<[lootTableName]>]>