dd_Create_Pathways:
    debug: false
    type: task
    definitions: world|maxSections
    script:
    #Save a timestamp to compare against. Pause for a tick if we're spending more than 1 tick doing this.
    - define checkTime <util.time_now>

    #Process each queued section
    - while !<[world].flag[dd_pathway_queue].is_empty>:
        #Failsafe - if we loop through this more than preconfigured count, just stop.
        - if <[loop_index]> >= <[maxSections]>:
            - narrate "<red><bold> *** STOPPING - Dungeon passed <[maxSections]> sections."
            - while stop
        - flag <[world]> dd_sectionCount:++

        #Process the next section
        - ~run dd_ProcessNextSection def.world:<[world]>

        #If we're spending too much time, wait a tick to slow down a bit
        - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
            - wait 1t
            - define checkTime <util.time_now>