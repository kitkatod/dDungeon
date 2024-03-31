dc_SpawnTables_AmbientSpawnLocationGrid:
    debug: false
    type: procedure
    definitions: loc
    script:
    #Round location to standardize
    - define loc <[loc].round>
    #Get remainder of div by 8, this will give us how far off the location is from the grid point
    - define modx <[loc].x.mod[8]>
    - define mody <[loc].y.mod[8]>
    - define modz <[loc].z.mod[8]>
    #Return grid point by subtracting out remainders
    - determine <[loc].sub[<[modx]>,<[mody]>,<[modz]>]>