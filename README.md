# dDungeon: Adds a robust Dungeon Generation tool to Denizen!
Minecraft Dungeon Generation toolset using Denizen Scripting.

* [Commands](/docs/commands.md)
* [Tools](/docs/tools.md)
* [Custom Events](/docs/customEvents.md)
* [Section Modifiers](/docs/standardSectionModifiers.md)

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
* [Section Modifiers!](docs/standardSectionModifiers.md)

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
- Depenizen ([GitHub](https://github.com/DenizenScript/Depenizen)) ([Release Builds](https://ci.citizensnpcs.co/job/Depenizen/))
- WorldEdit ([GitHub](https://github.com/EngineHub/WorldEdit)) ([Server Plugin](https://dev.bukkit.org/projects/worldedit))

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


### Configuration / Usage
- Configurable options are all saved within the /scripts/dDungeon/config folder. All configurable settings are documented within these files.