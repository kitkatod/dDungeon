# dDungeon: Adds a robust Dungeon Generation tool to Denizen!
Minecraft Dungeon Generation toolset using Denizen Scripting.

### Features:
* Create a Dungeon World generated randomly using user defined section schematics
* Most "random selections" allow for a "weight" to be applied, to allow some entries to appear more frequently than others
* Tools for creating/saving Dungeon Sections
* Automatic Flipping and Rotating of Dungeon Sections during generation to add variety
* Custom Loot Tables defined via Data Script
* Custom Spawn Tables defined via Data Script
* Ambient Mob Spawning around the player using a given Spawn Table name
* Setup spawners to use a specific Spawn Table
* Configurable Boss Bar for spawners
* Loot generated into Chests/Furnaces/any block with an Inventory
* Loot generated for Mob drops
* Multiple Dungeon Categories can be specified
* Multiple Dungeon Settings can be defined to generate the same Category of Dungeon, but with different settings
* Support for creating "sub-dungeons" - Areas that can be designed differently from the rest of the dungeon
* Automatically Apply/Remove player attributes as they enter and exit a Dungeon. Configured per Dungeon
* [Custom Events!](docs/customEvents.md)

![image](https://github.com/kitkatod/dDungeon/assets/100255227/302db807-985f-4996-976b-8f2540bb184d)

[YouTube Generation Preview](https://youtu.be/4291zh7caW4)

### Required Dependency:
- Denizen ([GitHub](https://github.com/DenizenScript/Denizen)) ([Release Builds](https://ci.citizensnpcs.co/job/Denizen/))

### Optional Dependencies:
**Used for turning entities spawned on Dungeon Spawn Tables into a Sentinel NPC. Not Required.**
- Depenizen ([GitHub](https://github.com/DenizenScript/Depenizen)) ([Release Builds](https://ci.citizensnpcs.co/job/Depenizen/))
- Citizens ([GitHub](https://github.com/CitizensDev/Citizens2))
- Sentinel ([GitHub](https://github.com/mcmonkeyprojects/Sentinel))

**Used for Dungeon Section Selection when creating/editing Sections. Not Required.**
- WorldEdit ([GitHUb](https://github.com/EngineHub/WorldEdit) ([Server Plugin](https://dev.bukkit.org/projects/worldedit))

### Updating Existing Install:
- **!!! ALWAYS BACKUP YOUR "/plugins/Denizen/scripts" FOLDER BEFORE DELETING ANYTHING !!!**
- On your server, delete the folder "/plugins/Denizen/scripts/dDungeon"
- Copy all files from the repository from "scripts/dDungeon"
- **GENERALLY** don't copy the "scripts/dDungeonData" files when updating. These files are specific for your server - feel free to change the contents!

### Installation:
- Save all contents of "scripts" folder to "/plugins/Denizen/scripts" within the Minecraft Server folder.
  - If updating an existing installation, only the files within "/scripts/dDungeon" need to be updated.
  - Files within "/scripts/dDungeonData" are example files, and can be modified to fit your server's needs.
- Configure Denizen in /plugins/Denizen/config.yml (These settings are used to allow Schematic Archiving when a user "deletes" a Dungeon Section Schematic)
  - Commands
    - Delete
      - Allow file deletion: **true**
    - FileCopy
      - Allow copying files: **true**
    - While
      - Max Loops: **0** (OR, just a **REALLY** high number... This is due to using a task based FloodFill algorithm when backfilling areas around the Dungeon. If you run into void spaces around the Dungeon and this isn't **0**, it's probably too low...)
- **If not using the provided dungeon schematics, you're done installing! Otherwise:**
-  Save all contents of "schematics" folder to "/plugins/Denizen/schematics".

### Commands:
- /ddTools
  - Gives the player the two tool items used to create/modify sections
  - First tool is a Schematic Section Editor, used for saving and making config changes to a Dungeon Section
  - Second tool can be swapped between all other minor-tools (Uses the "Swap Offhand" key, usually defaulted to "F")
    - Dungeon Pathway Tool: Used to specify entrances/exits to/from a Dungeon Section. This is the point where Sections connect to each other at.
    - Dungeon Inventory Tool: Used to configure loot spawning on an inventory
    - Dungeon Fake Block Tool: Used to flag a block as being fake. When dungeon generates the block will be replaced with air, and a matching block_display entity will be spawned
    - Dungeon Entrance Tool: Used to setup how to enter a dungeon created with /ddCreate. This uses the [DungeonKey], so the entrance/exit remains functional even if a dungeon is regenerated.
    - Dungeon Spawner Tool: Used to configure Spawners within Dungeon Sections
- /ddCreate [DungeonType] [DungeonKey]
  - Create a new dungeon in a new void world
  - DungeonType: Corresponds to a key saved in the script "/scripts/dDungeon/config/dungeonSettings.dsc"
  - DungeonKey: Can be any value, this is just used to identify the dungeon between regenerating a world
- /ddGoTo [DungeonKey]
  - Teleports the player to the configured Dungeon Entrance for the given Dungeon Key
- /ddPaste
  - Paste a given Dungeon Section file at the player's current location
  - A Clickable menu will open in chat to navigate to the Section to paste
- /ddDestroy [DungeonKey]
  - Destroys a dungeon world for the given DungeonKey (matches the one used in /ddCreate)
- /ddTestLootTable [LootTableName] [ReplaceInventoryLoot] [RepeatCount]
  - Roll the specified LootTable a number of times, using the inventory of the block you are looking at
  - If [ReplaceInventoryLoot] is true, it will wipe the inventory contents before each re-roll
  - Helpful for testing a Loot Table's output. (Don't forget to "/ex reload" after making changes to data scripts!)
 

### Configuration / Usage
- Configurable options are all saved within the /scripts/dDungeon/config folder. All configurable settings are documented within these files.
- All tools use either the player commands listed above, or use clickable chat messages.
- All tools and configuration options should have additional information when hovering over a clickable message. If something needs more clarity, let me know!
