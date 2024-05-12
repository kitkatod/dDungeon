# Commands:

### /ddTools
- Gives the player the two tool items used to create/modify sections
- Player can cycle between all available tools using the [SWAP HANDS] key, usually F.
- [List of and descriptions](/docs/tools.md)

---

### /ddCreate [DungeonType] [DungeonKey]
- Create a new dungeon in a new void world.
- DungeonType: Corresponds to a key saved in the script "/scripts/dDungeon/config/dungeonSettings.dsc".
- DungeonKey: Can be any value, this is just used to identify the dungeon between regenerating a world.
- If a world already exists with the given `DungeonKey`, that world will be destroyed and regenerated.

---

### /ddGoTo [DungeonKey]
- Teleports the player to the configured Dungeon Entrance for the given Dungeon Key

---

### /ddPaste
- Paste a given Dungeon Section file at the player's current location
- A Clickable menu will open in chat to navigate to the Section to paste

---

### /ddDestroy [DungeonKey]
- Destroys a dungeon world for the given DungeonKey (matches the one used in /ddCreate)

---

### /ddTestLootTable [LootTableName] [ReplaceInventoryLoot] [RepeatCount]
- Roll the specified LootTable a number of times, using the inventory of the block you are looking at
- If [ReplaceInventoryLoot] is true, it will wipe the inventory contents before each re-roll
- Helpful for testing a Loot Table's output. (Don't forget to "/ex reload" after making changes to data scripts!)

---

### /ddValidate
- Run dDungeon config validation.
- Will do simple checks against many configurations and schematics to look for errors.
