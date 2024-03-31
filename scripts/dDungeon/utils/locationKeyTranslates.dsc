dd_KeyToLocation:
    debug: false
    type: procedure
    definitions: key
    script:
    - determine <location[<[key]>]>

dd_LocationToKey:
    debug: false
    type: procedure
    definitions: location
    script:
    - define location <[location].round>
    - determine <[location].x>,<[location].y>,<[location].z>

dd_LocationWithoutWorld:
    debug: false
    type: procedure
    definitions: location
    script:
    - determine <[location].proc[dd_LocationToKey].proc[dd_KeyToLocation]>

dd_LocationWithoutWorld_KeepRotation:
    debug: false
    type: procedure
    definitions: location
    script:
    - define loc <[location].x>,<[location].y>,<[location].z>,<[location].pitch>,<[location].yaw>
    - determine <[loc].as[location]>