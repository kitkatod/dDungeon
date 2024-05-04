# Custom Events
The below Denizen Custom Events are available to listen to in your own scripts without modification to dDungeon.

* [dd_dungeon_section_placed](#dd_dungeon_section_placed)
* [dd_player_enters_dungeon](#dd_player_enters_dungeon)
* [dd_player_exits_dungeon](#dd_player_exits_dungeon)
* [dd_dungeon_spawner_destroyed](#dd_dungeon_spawner_destroyed)
* [dd_dungeon_spawned_entity_killed](#dd_dungeon_spawned_entity_killed)

---

### dd_dungeon_section_placed
- Fired for every Dungeon Section as it is placed.
- Useful for making modifications to dungeons after it is created.
- You may want to include an event switch to limit when your event is actually listening.
    - Such as `dungeon_key:{my_cool_key_here}` or `dungeon_category:stonebrick`

The below context data is passed when the event fires.

| Key | Description | Values |
| --- | --- | --- |
| area | Area containing the Section that was just placed | *AreaTag* |
| dungeon_key | Dungeon Key for the Dungeon this Section is in | *ElementTag* |
| dungeon_category | Dungeon Category used to create the Dungeon this Section is in | *ElementTag* |
| dungeon_section_type | Dungeon Section Type of this Section | *ElementTag* |
| dungeon_section_name | Name of this Dungeon Section | *ElementTag* |

---

### dd_player_enters_dungeon
- Fired when a player enters a Dungeon
- Note that this event fires for multiple reasons (e.g., player teleports into dungeon, player respawns, etc.)

The below context data is passed when the event fires.

| Key | Description | Values |
| - | - | - |
| location | Location of Player when entering Dungeon | *LocationTag* |
| reason | Underlying event causing this event to fire | PLAYER_RESURRECTED <br/> PLAYER_RESPAWNS <br/> PLAYER_TELEPORTS |


---

### dd_player_exits_dungeon
- Fired when a player leaves a Dungeon
- Note that this event fires for multiple reasons (e.g., player teleports into dungeon, player dies, etc.)

The below context data is passed when the event fires.

| Key | Description | Values |
| --- | --- | --- |
| location | Location of Player after leaving Dungeon | *LocationTag* |
| reason | Underlying event causing this event to fire | PLAYER_RESURRECTED <br/> PLAYER_RESPAWNS <br/> PLAYER_TELEPORTS |

---

### dd_dungeon_spawner_destroyed
- Fired when a Dungeon Spawner is destroyed (ie, players have killed enough Entities spawned from it).

The below context data is passed when the event fires.

| Key | Description | Values |
| --- | --- | --- |
| location | Location of the Spawner being destroyed | *LocationTag* |
| players | List of Players who have damaged at least one Entity spawned from this Spawner | *ListTag\<PlayerTag\>* |
| spawn_table | Name of Spawn Table the destroyed Spawner used <br/>*Spawn tables are defined in the script* _**dd_SpawnTables**_ | *element*<br/>library_guardians<br/>ambient_stonebrick<br/>etc..... |

---

### dd_dungeon_spawned_entity_killed
- Fired when an entity that was spawned by either a Dungeon Spawner or by Dungeon Ambient spawning is killed by a player.
- Has `player` linked to the player that the server considered killed the entity.

The below context data is passed when the event fires.

| Key | Description | Values |
| --- | --- | --- |
| spawner_location | Location of the Spawner this Entity was spawned from, if it was spawned by a Spawner.<br/>If spawned through ambient spawning this will be null. | *LocationTag*<br/>`null` |
| entity | Entity that was killed. | *EntityTag* |
| assisting_players | List of players who have damaged this Entity | *ListTag\<PlayerTag\>*
| spawn_table | Name of Spawn Table used to spawn this Entity | *element*<br/>library_guardians<br/>ambient_stonebrick<br/>etc..... |