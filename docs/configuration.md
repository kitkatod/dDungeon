# Configuration

Configuration options are set in different locations depending on the process area.

- [Global Options](#global-options) are in the script [dd_Config](/scripts/dDungeon/config/dDungeon.dsc)
- [Loot Table Options](#loot-tables) are in the script [dd_LootTables](/scripts/dDungeonData/lootTables.dsc)
- [Spawn Table Options](#spawn-tables) are in the script [dd_SpawnTables](/scripts/dDungeonData/spawnTables.dsc)
- [Dungeon Settings](#dungeon-settings) are in the script [dd_DungeonSettings](/scripts/dDungeonData/dungeonSettings.dsc)
- [Section Category & Type](#section-category--type) are configured based on the directory structure within the Denizen plugin folder on the server at ./plugins/Denizen/schematics/dDungeon.

---

### Global Options

Global options are configured within the script [dd_Config](/scripts/dDungeon/config/dDungeon.dsc), and control overall behavior of dDungeon scripts. This holds information like scripts version number and several debug toggles. 

This file can usually be left with their defaults, however it may be useful to modify for locating issues with Dungeon Sections.

---

### Loot Tables

Information for Loot Tables used by dDungeon scripts are configured within [dd_LootTables](/scripts/dDungeonData/lootTables.dsc).

TODO - Documentation page for Loot Tables. For now, see comments within example loot table configuration.

---

### Spawn Tables

Information for Spawn Tables used by dDungeon scripts are configured within [dd_SpawnTables](/scripts/dDungeonData/spawnTables.dsc).

TODO - Documentation page for Spawn Tables. For now, see comments within example spawn table configuration.

---

### Dungeon Settings

Information about configured Dungeons that can be generated, and are configured with [dd_DungeonSettings](/scripts/dDungeonData/dungeonSettings.dsc).

TODO - Documentation page for Dungeon Settings. For now, see comments within example configured dungeon.

---

### Section Category & Type

Controls what Dungeon Categories and Section Types are available within dDungeon tools, and is also where dDungeon will save all Section Schematics and Data files. The base save path for schematics on the server is ./plugins/Denizen/schematics/dDungeon.

The basic folder structure is `./dDungeon/{CATEGORY}/{SECTION-TYPE}/`. 
- Categories can be any valid directory name, with the exception that it cannot have a `_` prefix.
- Section Types can be any valid directory name though with some special exceptions.
    - Hallways and Deadends
        - Hallways and Deadends are treated differently within dDungeon. These are any types starting with `hallway_` or `deadend_`.
        - Several Hallways are placed to connect different connecting rooms.
        - Deadends are placed in situations where dDungeon cannot place any other section on a pathway due to lack of space or another reason. These are usually *very* small rooms and are just meant to cap a gaping hole in a hallway or doorway.
        - Hallways and Deadends must have a type suffix of `_{HALLWAY-TYPE}`. In this special case, the folder structure becomes `./dDungeon/{CATEGORY}/{SECTION-TYPE}_{HALLWAY-TYPE}/`.
        - For any given `hallway_{HALLWAY-TYPE}` there must be a matching `deadend_{HALLWAY-TYPE}`. The reverse is also true.
    - Spawn Room
        - A `spawn_room` type is always required. This is the first section type to be generated for any dungeon, and is where the player spawns into when entering the dungeon.

An example folder structure then may look like:
```
/dDungeon
|   /stonebrick
|   |   /hallway_default
|   |   /deadend_default
|   |   /hallway_special
|   |   /deadend_special
|   |   /my_basic_room_type
|   |   /my_super_awesome_room_type
|   |   /foo_and_bar
|   |   /spawn_room
```




