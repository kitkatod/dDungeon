dd_LootTables_GetData:
    debug: false
    type: procedure
    definitions: lootTableName
    script:
    - determine <script[dd_LootTables].data_key[lootTables.<[lootTableName]>].if_null[null]>