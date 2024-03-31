dd_SpawnTables_RandomSpawnableLoc:
    debug: false
    type: procedure
    definitions: loc|distance|ignoreLight
    script:
    #Get list of spawnable blocks
    - define spawnableBlocks <[loc].center.find_spawnable_blocks_within[<[distance].if_null[3]>]>

    - define dungeonArea <[loc].world.flag[dd_area]>

    #Try up to 30 times to find a spawn point that matches criteria
    - while <[loop_index]||0> <= 30 && !<[spawnableBlocks].is_empty>:
        - define cLoc <[spawnableBlocks].random>
        - define spawnableBlocks:<-:<[cLoc]>

        #Skip the location if it's outside the defined dungeon area
        - if !<[dungeonArea].contains[<[cLoc]>]>:
            - while next

        #Skip if light level is too high
        - if !<[ignoreLight].if_null[false]> && <[cLoc].light> >= 1:
            - while next

        - define distance <[cLoc].distance[<[loc]>]>
        #If ray trace returns null then no blocks are between the spawn point and this point. Use it!
        - if <[cLoc].ray_trace[range=<[distance]>]||null> == null:
            - determine <[cLoc]>

    #Fallback is just to return the input location...
    - determine <[loc]>