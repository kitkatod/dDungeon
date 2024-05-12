# General Overview

dDungeon is intended to be used to create a semi-random Dungeon within a dedicated Minecraft world, supporting Mob Spawning and Loot Generation.

---

## Terms

| Term | Description |
| --- | --- |
| Dungeon Section | The smallest piece of a Dungeon. Sections are saved with a Category and Type using the [Schematic Section Editor Tool](/docs/tools.md#schematic-section-editor). |
| Section Type | Defines the structural purpose of a Section. Is it a hallway? Spawn room? Boss room? Small closet?<br/>`spawn_room`, `deadend_default`, and `hallway_default` are used by default, however any additional Section Types may be defined. |
| Section Category | Used to define the "Theme" of Sections. Section Types are grouped into Section Categories.<br/>Used in [Dungeon Settings](/docs/configuration.md#dungeon-settings). |
| Section Pathway | A Pathway a marker within a Section defining where other Sections can connect to. A number of options are available on the [Pathway Tool](/docs/tools.md#dungeon-pathway-tool) to control the behavior of Dungeon Generation when it comes to Pathways. |
| Dungeon Type | Group of settings used to generate a Dungeon, identified by a Dungeon Key. Configured in [Dungeon Settings](/docs/configuration.md#dungeon-settings). |
| Loot Table | Custom configuration and logic to generate a list of items. Used to determine Mob Drops when they die, and Items found in chests. See [docs](/docs/configuration.md#loot-tables) for configuration options. |
| Spawn Table | Custom configuration and logic to generate Mobs to spawn. Used by Ambient Spawning and Dungeon Spawners. See [docs](/docs/configuration.md#spawn-tables) for configuration options. |
| Ambient Spawning | Spawning process that takes place around a player within a Dungeon. See [docs](/docs/configuration.md#dungeon-settings) for how to specify an Ambient Spawn table for a Dungeon |
| Dungeon Spawner | Special Spawner within a Dungeon which spawns Mobs based on configured options on the Spawner. Note: This isn't a real Minecraft Spawner block. Dungeon Spawners are created/updated within a Dungeon Section using the [Dungeon Spawner Tool](/docs/tools.md#dungeon-spawner-tool). |
| Spawn Points | Arbitrary number determining the "worth" of a Mob. Used to help decide how many mobs should be spawned. |


---

## Dungeon Generation Process

Dungeon Generation occurs generally using the below outline. Note that this does not cover *every* step of generation, and is just meant to provide a bit of context as to how the process works.

- Dungeon Generation starts usually with the [/ddCreate](/docs/commands.md#ddcreate-dungeontype-dungeonkey) command.
- A new totally empty world is created to build the Dungeon within.
- A randomly picked Section from the `spawn_room` type is placed and any pathways on the section are queued to be processed
- For each queued pathway:
    - If the pathway specifies to "Reset Hallway Count", a random number is generated and remembered. While the number is above zero try to place a Hallway section. Each time a Hallway is placed, decrease this number. Generation *MAY* in some scenarios place more hallways, however this is only a fallback in case the configured "Next Room Type" cannot be placed due to there not being enough space for it.
    - If the pathway specifies a "Next Room Type", this is remembered for that branch of dungeon until Generation either places that type of room, or until another section overrides it by specifying a "Next Room Type".
    - If neither the requested Section Type or a Hallway section could be placed, try to place a section from the appropriate `deadend_` category.
    - Any configured Inventories in the section are queued to generate loot later.
    - Any configured pathways in the section (minus the one that is already connected to the Dungeon) are queued to be processed.
- Once all queued pathways are processed, loot is generated for all configured Inventories following Loot Table logic.
- If configured for the Dungeon Type, fill in any empty space outside of the Dungeon with a solid block.
- After everything has been placed and backfilled, Ambient Spawning and Dungeon Spawners within the Dungeon are periodically processed to spawn mobs as needed.