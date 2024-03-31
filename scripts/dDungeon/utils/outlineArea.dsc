dd_OutlineArea:
    debug: false
    type: task
    definitions: area|color|duration|for
    script:
    - if !<[area].exists>:
        - stop
    - define chunk <[area].blocks.first.chunk>
    - if !<[chunk].is_loaded>:
        - stop
    - if !<[for].exists>:
        - define for <player>
    - foreach <[area].shell.random[<[area].shell.size>]> as:loc:
        - define locs<[loop_index].mod[3]>:->:<[loc]>
    - define stopTime <util.time_now.add[<[duration].if_null[10s]>]>
    - while <util.time_now.is_before[<[stopTime]>]>:
        - if !<[chunk].is_loaded>:
            - stop
        - playeffect effect:REDSTONE special_data:2|<[color].if_null[yellow]> at:<[locs<[loop_index].mod[3]>]> offset:0 quantity:1 targets:<[for]>
        - wait 7t