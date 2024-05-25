# Configuration

Configuration options are set in different locations depending on the process area.

- [Global Options](#global-options) are in the script [dd_Config](/scripts/dDungeon/config/dDungeon.dsc)
- [Loot Table Options](#loot-tables) are in the script [dd_LootTables](/scripts/dDungeonData/lootTables.dsc)
- [Spawn Table Options](#spawn-tables) are in the script [dd_SpawnTables](/scripts/dDungeonData/spawnTables.dsc)
- [Dungeon Settings](#dungeon-settings) are in the script [dd_DungeonSettings](/scripts/dDungeonData/dungeonSettings.dsc)
- [Section Category & Type](#section-category--type) are configured based on the directory structure within the Denizen plugin folder on the server at ./plugins/Denizen/schematics/dDungeon.

---

### Global Options

Global options are configured within the script [dd_Config](/scripts/dDungeon/config/dDungeon.dsc), and control overall behavior of dDungeon scripts. This holds information like saving configurations and several debug toggles. 

This file can usually be left with their defaults, however it may be useful to modify for locating issues with Dungeon Sections, or if you use custom flags within dungeon sections.

---

### Loot Tables

Information for Loot Tables used by dDungeon scripts are configured within [dd_LootTables](/scripts/dDungeonData/lootTables.dsc). Loot Tables can be used to define what loot generates in blocks with an inventory such as Chests, Barrels, Furnaces, etc. Loot Tables can also be used to define what loot drops for an entity spawned from a Spawn Table when they die. 

Inventories are configured with a Loot Table using the [Dungeon Inventory Tool](/docs/tools.md#dungeon-inventory-tool). See [Spawn Tables Configuration](#spawn-tables) for details on using Loot Tables with Spawn Tables.



**Expected Script Format:**
- [Loot Table Name]: Can be any name as long as it is not used more than once.
- [Loot Table Settings]: Is always prefixed with `_`, see below for available options
- [Loot Table Item]: Cannot start with `_`. Must be either the name of an item or a procedure script which returns an item. If `#` is specified in the item name then anything after `#` is ignored

```
dd_LootTables:
    debug: false
    type: data
    lootTables:
        [Loot Table Name]:
            [Loot Table Settings]:
            [Loot Table Item]:
                [Loot Table Item Settings]
```

**Loot Table Settings**

| Config Key | Required | Type | Description | Default |
| --- | --- | --- | --- | --- |
| _selection_count | OPTIONAL | *ElementTag(Integer)*<br/>*ListTag(ElementTag(Integer))* | Determines the number of item entries to pick when this Loot Table is called.<br/>Can also specify a range using the format `min\|max` and a number will be randomly picked each time within the range. | 1 |
| _import_from | OPTIONAL | *ListTag(ElementTag)* | When specified, all Item entries from another Loot Table will be imported to this Loot Table. <br/>NOTE: This does not allow import chaining. Item keys must also still be unique or will be ignored. Loot Table Settings are not imported from other Loot Tables. | *NULL* |
| _allow_split_stack | OPTIONAL | *ElementTag(Boolean)* | Applies a default `allow_split_stack` setting to all Item entries in this Loot Table | *NULL* |
| _flags | OPTIONAL | *MapTag* | Applies a default `_flags` settings to all Item entries in this Loot Table. | *NULL* |


**Loot Table Item Settings**
| Config Key | Required | Type | Description | Default |
| --- | --- | --- | --- | --- |
| quantity | OPTIONAL | *ElementTag(Integer)* | Quantity of the item to give.<br/>May be a range using the format `min\|max`, in which case a random value will be selected each time within the range. | 1 |
| allow_split_stack | OPTIONAL | *ElementTag(Boolean)* | When `quantity` is greater than 1 and the item allows stacking, this will split the item quantity into multiple not-full item stacks.<br/>Max stack size for an item is always respected regardless settings. | true |
| weight | OPTIONAL | *ElementTag(Decimal)* | Weight value for this Item entry on the Loot Table.<br/>Higher weight values are more likely to be picked than lower weight values. | 100 |
| max_selection_count | OPTIONAL | *ElementTag(Integer)* | Sets the maximum number of times this entry can be picked when the Loot Table is called.<br/>Only has an effect if the Loot Table Setting `_selection_count` is greater than 1.<br/>Use the value -1 to allow this to be picked an unlimited number of times. | -1 |
| randomize_durability | OPTIONAL | *ElementTag(Boolean)* | Randomize the durability of the resultant item if possible, weighted towards the lower end of durability. | true |
| _flags | OPTIONAL | *MapTag* | Map of flags to apply to the item. | *NULL* |
| item_proc_args | OPTIONAL | *ElementTag*<br/>*ListTag*<br/>*MapTag*<br/>*etc....* | If the Loot Table Entry key is the name of a Procedure Script, optionally pass data to the Procedure when it is executed. | *NULL* |
| modifier_procs | OPTIONAL | *MapTag* | Procedures defined here will be passed the item and can make changes to the item based on custom logic.<br/>Map keys here should be the name of a procedure script. The value of the entry will be passed to the procedure as context. | *NULL* |

---

### Spawn Tables

Information for Spawn Tables used by dDungeon scripts are configured within [dd_SpawnTables](/scripts/dDungeonData/spawnTables.dsc) and control logic for spawning mobs for either Ambient Spawning or Dungeon Spawners.

**Expected Script Format:**
- [Spawn Table Name]: Identifier for the Spawn Table - can be anything as long as it is not used more than once.
- [Spawn Table Settings]: Is always prefixed with `_`, see below for available options. Controls options for the Spawn Table.
- [Spawn Table Mob]: Cannot start with `_`. Must be the name of an Entity Type, or the script name of a Denizen Entity Script. Determines what mobs can be spawned for the table.

```
dd_SpawnTables:
    debug: false
    type: data
    spawnTables:
        [Spawn Table Name]:
            [Spawn Table Settings]:
            [Spawn Table Mob]:
```


**Spawn Table Settings**

| Config Key | Required | Type | Description | Default |
| --- | --- | --- | --- | --- |
| _selection_count | OPTIONAL | *ElementTag(Integer)* | Number of Mob Entries to pick from this Spawn Table when it is run. | 1 |
| _loot_table | OPTIONAL | *ElementTag* | Default setting to apply to all Mob Entries in this Spawn Table | NO_DROPS |

**Spawn Table Mob Settings**

| Config Key | Required | Type | Description | Default |
| --- | --- | --- | --- | --- |
| _loot_table | OPTIONAL | *ElementTag* | Name of a Loot Table from [dd_LootTables](/scripts/dDungeonData/lootTables.dsc). Loot Table will be run when this entity dies and the items from the Loot Table will be dropped. | NO_DROPS |
| spawn_count | OPTIONAL | *ElementTag(Integer)* | Number of entities of this type to spawn. | 1 |
| weight | OPTIONAL | *ElementTag(Integer)* | Weight value for this Mob on the Spawn Table to be randomly picked.<br/>Higher weight values are more likely to be picked than lower weight values. | 100 |
| spawn_points | OPTIONAL | *ElementTag(Decimal)* | The base number of Spawn Points this entity should be "worth" when it is spawned. Number of Spawn Points allowed to be spawned per run is controlled by [Dungeon Settings](#dungeon-settings) for Ambient Spawning and the [Dungeon Spawner Tool](/docs/tools.md#dungeon-spawner-tool) for Dungeon Spawners. | 1 |
| modifier_tasks | OPTIONAL | *MapTag* | Tasks that should be run after the mob has been spawned.<br/>Key should be the name of a Task Script to be run, and any values will be passed to that Task. See below for additional configuration options available. | *NULL* |

**Mob Modifier Tasks**
- Specified tasks will always be passed a reference to the spawned entity with the "entity" definition.
- If a Map of values are specified for the task then all keys/values will be passed to the task with matching names.
    - For example, if `myCoolParameter: 12345` is specified, then the definition `myCoolParameter` on the Task script will be given the value `12345`.
- If there is a `_chance` specified for the Task entry, then the task will only be run that percentage of the time. Default is to always run the task if specified.
- If for some reason the task needs to kill/replace the mob entirely, you may determine the new entity within the Task using `- determine entity:<EntityTag>`.

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
| backfill_dungeon | OPTIONAL | *ElementTag(Boolean)* | Whether to fill in outside air blocks around the Dungeon Sections with a solid block. | true |
| backfill_dungeon_material | OPTIONAL | *ElementTag*<br/>*ListTag(ElementTag)* | If `backfill_dungeon` is true, controls what material(s) to backfill the Dungeon with. | stone |
| ambient_spawn_table | OPTIONAL | *ElementTag* | Name of the Spawn Table to use for Ambient Spawning logic.<br/>This will periodically spawn mobs from the Spawn Table around players within the Dungeon. | *NULL* |
| ambient_spawn_points_per_player | OPTIONAL | *ElementTag(Decimal)* | Sum of Spawn Points allowed to be spawned around a player.<br/>Ambient Spawning will continue to spawn mobs to try to reach this value. | 10 |
| ambient_spawn_points_per_grid_section_max | OPTIONAL | *ElementTag(Decimal)* | Maximum number of Spawn Points worth of mobs to for Ambient Spawning to ever spawn in a 8x8x8 grid section of the Dungeon.<br/>Once this value is reached Ambient Spawning will not spawn mobs in that grid section of the Dungeon. | 50 |
| ambient_spawn_player_delay_period | OPTIONAL | *DurationTag* | After Ambient Spawning spawns mobs for a specific player, it will not trigger again for this duration of time.<br/>NOTE: If there are multiple players in an area, it will still continue trying to spawn for the other players. | 10s |
| ambient_spawn_relative_to_player | OPTIONAL | *ElementTag* | For Ambient Spawning in the Dungeon, whether to restrict spawning to in front of or behind players. This is always ignored if there is not line of sight between the player and the spawn location.<br/>FORWARD: Only allow spawning in front of players.<br/>BEHIND: Only allow spawning behind players.<br/>BOTH: Ignore relative position, allow spawning in front of or behind players. | BOTH |
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




