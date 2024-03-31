dd_Pathways_RandomWeightedOrder:
    debug: false
    type: procedure
    definitions: possible_connections
    script:
    - define randList <list[]>
    - foreach <[possible_connections].keys> as:connectionType:
        - define chance <[possible_connections.<[connectionType]>.chance]>
        - repeat <[chance]>:
            - define randList:->:<[connectionType]>

    - define outputList <list[]>
    - while !<[randList].is_empty>:
        - define nextType <[randList].random>
        - define randList <[randList].exclude[<[nextType]>]>
        - define outputList:->:<[nextType]>

    - determine <[outputList]>
