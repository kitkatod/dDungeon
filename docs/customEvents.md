# Custom Events
The below Denizen Custom Events are available to listen to in your own scripts without modification to dDungeon.

* [dd_player_enters_dungeon](#dd_player_enters_dungeon)
* [dd_player_exits_dungeon](#dd_player_exits_dungeon)
* [dd_dungeon_spawner_destroyed](#dd_dungeon_spawner_destroyed)

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
- Fired when a Dungeon Spawner is destroyed (ie, players have killed enough Entities spawned from it)

The below context data is passed when the event fires.

| Key | Description | Values |
| --- | --- | --- |
| location | Location of the Spawner being destroyed | *LocationTag* |
| players | List of Players who have damaged at least one Entity spawned from this Spawner | *ListTag\<PlayerTag\>* |
| spawn_table | Name of Spawn Table the destroyed Spawner used <br/>*Spawn tables are defined in the script* _**dd_SpawnTables**_ | library_guardians<br/>ambient_stonebrick<br/>etc.....