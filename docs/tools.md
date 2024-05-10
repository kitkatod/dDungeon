# Tools

With one dDungeon tool item you can can cycle through all tools by pressing the `SWAP HANDS` key, default is usually `F`. Holding `SHIFT` while cycling tools will cycle to the previous tool instead of the next tool.

All tools are usually used by right clicking a block with the tool, then using the menu displayed in Chat to make changes.

All menu options for tools have additional hints when hovering over an option in chat.

---

### Schematic Section Editor
- This is the main tool for setting up Dungeon Sections.
- Used for saving and making config changes to a Dungeon Section.

---

### Dungeon Pathway Tool
- This is the tool to mark where Dungeon Sections may connect to one another.
- Used for defining the direction of the pathway and other options.

---

### Dungeon Inventory Tool
- When used on an Inventory block (Chest, Barrel, Furnace, etc.), opens a menu to configure generated loot options.

---

### Dungeon Fake Block Tool
- Used to flag a block as being a "Fake Block".
- During Dungeon Generation all "Fake Block"s are changed to air, and an identical Display Block Entity is put in its place to match the block removed.
- This is handy for making "Secret Entrance" type dungeon features.

---

### Dungeon Entrance Tool
- NOTE: This is used *outside* Dungeon Sections.
- Used to setup how to enter an existing dungeon that was created with [/ddCreate](/docs/commands.md#ddcreate-dungeontype-dungeonkey).
- This uses the [DungeonKey], so the entrance/exit remains functional even if a dungeon is regenerated.

---

### Dungeon Spawner Tool
- Used to configure special Spawners within Dungeon Sections.
- Spawners are not real Minecraft "Spawner" blocks. There is logic running to spawn entities based on the configured options.
