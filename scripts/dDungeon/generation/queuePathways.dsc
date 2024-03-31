dd_QueuePathways:
    debug: false
    type: task
    definitions: loc|sectionOptions|buildVariables
    script:
    #Get options object
    - define pathways <[sectionOptions.pathways].if_null[<map[]>]>
    - define buildVariables <[buildVariables].if_null[<proc[dd_StartingBuildVariables]>]>

    #Loop through each pathway block
    #Find where each next section will go and queue the section
    - foreach <[pathways].keys> as:pathwayOffset:
        #Starting values
        #Options for the current pathway
        - define pathOptions <[pathways.<[pathwayOffset]>]>
        - define direction <[pathOptions.direction]>

        #Find where pathway starts
        - define pasteLoc <[loc].add[<[pathwayOffset]>].add[<[direction]>]>

        #Create a map with settings needed for this pathway
        - define pathQueueEntry <map[]>
        - define pathQueueEntry.pasteLoc <[pasteLoc]>
        - define pathQueueEntry.buildVariables <[buildVariables]>
        - define pathQueueEntry.pathOptions <[pathOptions]>
        - define pathQueueEntry.previousType <[sectionOptions.type]>

        #Add to list to be returned on this queue
        - flag <[loc].world> dd_pathway_queue:->:<[pathQueueEntry]>

        #- announce "Queued <[pasteLoc]>"
