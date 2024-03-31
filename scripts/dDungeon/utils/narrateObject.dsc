dd_NarrateObject:
    debug: false
    type: task
    definitions: obj|message|skipNarrate|prefix
    script:
    #Clean parameters
    - define skipNarrate <[skipNarrate].if_null[false]>
    - define prefix <[prefix].if_null[]>
    - define message <[message].if_null[Data]>

    #Announce if needed
    - if <[skipNarrate]> = false:
        - narrate "<blue><italic> \/ \/ \/ <[message]> \/ \/ \/"

    #Process object
    - choose <[obj].object_type>:
        - case map:
            - foreach <[obj].keys.alphabetical> as:key:
                - narrate <[prefix]><[key]>=(<[obj.<[key]>].object_type>)
                - ~run dd_NarrateObject def.obj:<[obj.<[key]>]> def.skipNarrate:true "def.prefix:<[prefix]>  "
        - case list:
            - foreach <[obj]> as:item:
                - narrate "<[prefix]>(List Index <[loop_index]>)"
                - ~run dd_NarrateObject def.obj:<[item]> def.skipNarrate:true "def.prefix:<[prefix]>  "
                #- narrate <[prefix]><[item]>
        - default:
            - narrate <[prefix]><[obj]>

    #Announce if needed
    - if <[skipNarrate]> = false:
        - narrate "<blue><italic> /\ /\ /\ <[message]> /\ /\ /\"