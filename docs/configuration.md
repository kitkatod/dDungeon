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

Information about configured Dungeons that can be generated, and are configured with [dd_DungeonSettings](/scripts/dDungeonData/dungeonSettings.dsc). Dungeon Keys are specified here, and act as a way to specify what set of settings to use during generation.

**Expected Script Format:**
```
dd_DungeonSettings:
    debug: false
    type: data
    dungeons:
        my_cool_dungeon_key_here:
            category: Stonebrick
            section_count_soft_max: 450
            section_count_hard_max: 500
            ## [Additional config options here]
```

| Config Key | Required | Type | Description | Default |
| --- | --- | --- | --- | --- |
| category | REQUIRED | *ElementTag* | Category of Dungeon Sections to use for this Dungeon | N/A |
| section_count_soft_max | OPTIONAL | *ElementTag(Integer)* | Cap of sections to place. Pathways after this cap will only attempt to place deadend section types | 450 |
| section_count_hard_max | OPTIONAL | *ElementTag(Integer)* | Absolute max number of sections to place. Pathways after this count has been reached will be skipped entirely. | 500 |
| allowed_build_space | OPTIONAL | *ElementTag(Integer)* | Number of blocks around the Spawn Room to allow the Dungeon to be generated within.<br/>This just helps restrict the generation process from sprawling when not needed.<br/>Disable this by setting to a very high number such as 1000. | 40 |
| ambient_spawn_table | OPTIONAL | *ElementTag* | Name of the Spawn Table to use for Ambient Spawning logic.<br/>This will periodically spawn mobs from the Spawn Table around players within the Dungeon. | *NULL* |
| ambient_spawn_points_per_player | OPTIONAL | *ElementTag(Decimal)* | Sum of Spawn Points allowed to be spawned around a player.<br/>Ambient Spawning will continue to spawn mobs to try to reach this value. | 10 |
| ambient_spawn_points_per_grid_section_max | OPTIONAL | *ElementTag(Decimal)* | Maximum number of Spawn Points worth of mobs to for Ambient Spawning to ever spawn in a 8x8x8 grid section of the Dungeon.<br/>Once this value is reached Ambient Spawning will not spawn mobs in that grid section of the Dungeon. | 50 |
| ambient_spawn_player_delay_period | OPTIONAL | *DurationTag* | After Ambient Spawning spawns mobs for a specific player, it will not trigger again for this duration of time.<br/>NOTE: If there are multiple players in an area, it will still continue trying to spawn for the other players. | 10s |
| special_loot_tables | OPTIONAL | *ListTag(Element)* | Any loot table names specified here will only have loot calculated once for the entire Dungeon. Items will be distributed among any chest/inventory configured with this Loot Table | *NULL* |
| global_loot | OPTIONAL | *ListTag(Element)* | Similar to special_loot_tables, however items are instead distributed among ALL chest/inventories, instead of only ones configured with the Loot Table.<br/>Useful for placing item(s) SOMEWHERE in the Dungeon, without needing to configure every chest. | *NULL* |
| player_attributes | OPTIONAL | *MapTag* | Attributes to apply to players that are in the Dungeon. Attributes will automatically be applied/removed as needed when players enter/teleport/respawn/die/etc.<br/> | *NULL* |

**player_attributes Example:**
```
player_attributes:
    generic_max_health:
    - <map[operation=ADD_NUMBER;amount=20]>
```


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




