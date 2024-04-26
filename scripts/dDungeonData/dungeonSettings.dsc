dd_DungeonSettings:
    debug: false
    type: data
    dungeons:
        #This name can be anything. It is used with either the dd_Create task, or the /createDungeon command
        StonebrickDefault:
            #Category of dungeon sections for this dungeon
            category: Stonebrick
            #Cap of sections to place. Pathways after this cap will attempt to only place deadends
            section_count_soft_max: 450
            #Cap of sections to place. Generation process will fully stop after this many sections have been placed.
            section_count_hard_max: 500
            #Task specified here will be triggered for each section placed
            #Definitions are expected to be [cuboid] and [type] (ex: "definitions: cuboid|type")
            noise_generation_task: dd_NoiseGeneration_Stonebrick
            #Buffer around the spawn room to allow sections to be placed within.
            #This just helps restrict the generation process from sprawling into open space when it doesn't need to.
            #To disable this just set it to a very high number
            allowed_build_space: 140
            #Spawn Table to use when spawning in ambient mobs for this dungeon
            ambient_spawn_table: ambient_stonebrick
            #Per-Player max sum of spawn-points currently alive around a player
            #SpawnPoints are saved on each spawned mob, and totaled for all mobs nearby the player
            #Helps control how many mobs (and how strong of mobs) may spawn in a given area before stopping spawning
            #More players in a small area will scale this up when spawning mobs
            ambient_spawn_points_per_player: 6
            #Maximum number of Spawn Points to spawn into each grid section of the dungeon for ambient spawning.
            #A grid section is just an 8x8x8 section in the dungeon. Used to track "how much has ever spawned in this part of the dungeon".
            ambient_spawn_points_per_grid_section_max: 30
            #Delay ambient dungeon spawning for a given player for this amount of time after spawning for the player
            #May still spawn mobs for other players nearby
            ambient_spawn_player_delay_period: 3m

            #Any loot tables listed here will be rolled only once for the entire dungeon
            #Items returned for the loot table will be spread out among each of the chests flagged with the loot table
            special_loot_tables:
            - special_1
            - special_2
            - special_3

            #Any loot tables listed here will each be rolled once each for the entire dungeon
            #Items return for all the below loot tables will be spread out among all chests flagged in the dungeon, regardless of what the chest would normally have
            # global_loot:
            # - special_enchanted_books_for_everyone

            #The below attributes will be applied to players entering the dungeon, and removed after leaving
            #Attribute ids are randomly generated when the dungeon is created. If "id" is included in an attribute map below it will be overwritten during generation.
            #(Optional)
            player_attributes:
                generic_max_health:
                - <map[operation=ADD_NUMBER;amount=20]>

        StonebrickSmall:
            category: Stonebrick
            section_count_soft_max: 250
            section_count_hard_max: 300
            noise_generation_task: dd_NoiseGeneration_Stonebrick
            allowed_build_space: 40
            ambient_spawn_points_per_player: 10