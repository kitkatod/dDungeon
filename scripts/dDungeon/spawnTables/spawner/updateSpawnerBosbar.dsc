dc_SpawnTables_UpdateSpawnerBossbar:
    debug: false
    type: task
    definitions: spawnerLoc
    script:
    - define spawnerData <[spawnerLoc].flag[dd_spawner].if_null[null]>
    - if <[spawnerData]> == null:
        - stop

    #Stop if bank is disabled, don't know what the progress should show. Maybe always 100%...
    - if <[spawnerData.bank]> == null:
        - stop

    #Get spawner's bossbar settings
    - define radius <[spawnerData.bossbar_radius].if_null[10]>
    - define title <[spawnerData.bossbar_title].if_null[Spawner Health].parsed>
    - define color <[spawnerData.bossbar_color].if_null[RED]>
    - define enableFog <[spawnerData.bossbar_fog_enabled].if_null[true]>
    - define options <list[]>
    - if <[enableFog]>:
        - define options:->:CREATE_FOG

    #Get list of players within bossbar radius
    - define players <[spawnerLoc].find_players_within[<[radius]>]>

    #Check players who have the spawner's bossbar already, hide if the player isn't within radius anymore
    - define exitedPlayers <[spawnerData.bossbarPlayers].if_null[<list[]>].exclude[<[players]>]>
    - if !<[exitedPlayers].is_empty>:
        - bossbar remove <[spawnerData.bossbarId]> players:<[exitedPlayers]>

    #Determine progress
    - define progress <[spawnerData.currentBank]>
    - define progress:+:<[spawnerData.currentlySpawnedPoints]>
    - define progress:/:<[spawnerData.bank]>

    - if <[progress]> > 1:
        - define progress 1
    - else if <[progress]> < 0:
        - define progress 0


    #If spawner's progress is still positive then show the bossbar
    - if <[progress]> > 0:
        #Show bossbar
        - bossbar auto <[spawnerData.bossbarId]> players:<[players]> title:<[title]> progress:<[progress]> style:SOLID color:<[color]> options:<[options]>
        #Track bossbar players on the spawner
        - flag <[spawnerLoc]> dd_spawner.bossbarPlayers:<[players]>

    - else:
        #Remove the bossbar if progress is zero
        - bossbar remove <[spawnerData.bossbarId]> players:<[spawnerData.bossbarPlayers]>
        - flag <[spawnerLoc]> dd_spawner.bossbarPlayers:<list[]>
