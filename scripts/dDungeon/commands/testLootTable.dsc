dd_TestLootTableCommand:
    debug: false
    type: command
    name: ddTestLootTable
    description: Admin - Roll Loot Table with the inventory (chest) you're looking at. Optionally replace inventory contents with loot table results.
    usage: /ddTestLootTable [LootTableName] [ReplaceInventoryLoot] [RepeatCount]
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    tab completions:
        1: <script[dd_LootTables].data_key[lootTables].keys>
        2: <list[true|false]>
        3: <util.list_numbers[from=1;to=20]>
    script:
    - define lootTable <context.args.get[1].if_null[null]>
    - define wipeInventory <context.args.get[2].if_null[null]>
    - define repeatCount <context.args.get[3].if_null[null]>

    - if <[lootTable]> == null || <[wipeInventory]> == null || <[repeatCount]> == null || !<[wipeInventory].is_boolean>:
        - narrate "<red> *** Invalid syntax.<n>/ddTestLootTable [LootTableName] [ReplaceInventoryLoot] [RepeatCount]"
        - stop

    - if !<script[dd_LootTables].data_key[lootTables].keys.contains[<[lootTable]>]>:
        - narrate "<red> *** LootTable not found: <[lootTable]>"
        - stop

    - define inv <player.cursor_on[5].inventory.if_null[null]>
    - if <[inv]> == null:
        - narrate "<red> *** Must be looking at a block that has an inventory."
        - stop

    - narrate "<green> * Rolling LootTable <[lootTable]> <[repeatCount]> times"
    - repeat <[repeatCount]>:
        - if <[wipeInventory]>:
            - inventory clear destination:<[inv]>

        - ~run dd_rollLootTable_Inventory def.inventory:<[inv]> def.categories:<list[<[lootTable]>]>
        - wait 3s
