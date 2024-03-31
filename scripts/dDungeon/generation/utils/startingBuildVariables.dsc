dd_StartingBuildVariables:
    debug: false
    type: procedure
    script:
    - define map <map[]>
    - define map.hallwaysRemaining 0
    - define map.hallwayType default
    #- define map.turnChanceOffset -50
    #- define map.deadEndChance -10
    #- define map.nextRoomType
    - determine <[map]>