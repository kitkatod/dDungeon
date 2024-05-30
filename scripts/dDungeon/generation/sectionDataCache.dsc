dd_SectionDataCache_Prepare:
    debug: false
    type: task
    definitions: world
    script:
    - define category <[world].flag[dd_DungeonSettings.category]>

    #Save data for all the sections
    - define typeList <util.list_files[schematics/dDungeon/<[category]>]>
    - foreach <[typeList]> as:type:
        - define sectionList <util.list_files[schematics/dDungeon/<[category]>/<[type]>]>
        - if <[sectionList].is_empty>:
            - foreach next
        - foreach <[sectionList]> as:name:
            #Skip non-YAML files
            - if !<[name].ends_with[.yml]>:
                - foreach next
            #Load the YAML file data
            - ~yaml id:ddungeon_<queue.id> load:schematics/dDungeon/<[category]>/<[type]>/<[name]>
            - define sectionOptions <yaml[ddungeon_<queue.id>].read[SectionOptions]>
            - ~yaml id:ddungeon_<queue.id> unload

            #Get the section name group and variant
            - define nameGroup <[name].before[.yml].regex[([a-zA-Z_-]*)(_\d*)?$].group[1]>
            - define variantNumber <[name].before[.yml].regex[([a-zA-Z_-]*)(_\d*)?$].group[2].after[_]>

            #Save the name group to the section's data
            - define sectionOptions.nameGroup <[nameGroup]>

            #Save list of pathway directions
            - define pathDirectionList <list[]>
            - foreach <[sectionOptions.pathways]> key:offset as:pathOptions:
                - if <[pathOptions.allowIncoming].if_null[true]>:
                    - define pathDirectionList:->:<[pathOptions.direction].round>
            - define sectionOptions.pathway_directions <[pathDirectionList].deduplicate>

            #Save the (mostly) untouched data to the world
            - flag <[world]> dd_sectionData.<[category]>.<[type]>.<[name].before[.yml]>:<[sectionOptions]>

            #Add full name to list under the name group
            - flag <[world]> dd_sections.<[category]>.<[type]>.<[nameGroup]>.names:->:<[name].before[.yml]>

            #If there isn't a variant number, just set it to one (it's the only one)
            - if <[variantNumber].length> == 0:
                - define variantNumber 1

            #If it's the "main" variant, save the group name with the section's weight and any other starting values
            - if <[variantNumber]> == 1:
                - flag <[world]> dd_sections.<[category]>.<[type]>.<[nameGroup]>.weight:<[sectionOptions.chance].if_null[100]>
                - flag <[world]> dd_sections.<[category]>.<[type]>.<[nameGroup]>.occurrences:0
                - flag <[world]> dd_sections.<[category]>.<[type]>.nameGroups:->:<[nameGroup]>

        #PreProcess the list of section nameGroups to get a running weight sum.
        #This will be used to quickly determine a weighted-random order of entries.
        - define nameGroupList <[world].flag[dd_sections.<[category]>.<[type]>.nameGroups]>
        - define runningSum 0
        - foreach <[nameGroupList]> as:nameGroup:
            - define runningSum:+:<[world].flag[dd_sections.<[category]>.<[type]>.<[nameGroup]>.weight]>
            - flag <[world]> dd_sections.<[category]>.<[type]>.<[nameGroup]>.weight_target:<[runningSum]>
        - flag <[world]> dd_sections.<[category]>.<[type]>.total_weight:<[runningSum]>


    #Target Structure
    #
    #dd_sections.[category].[type]
    #                            .[grouped_name]
    #                                           .weight (set from "_1" variant of section)
    #                                           .weight_target (set after all groups are loaded, the running sum of weights)
    #                                           .names (list of all file names under this group)
    #                            .totalWeight (sum of all [grouped_name].weight - used for randomization)
    #                            .nameGroups (list of the valid grouped_name values)
    #dd_sectionData.[category].[type].[name]:[sectionData]


dd_SectionDataCache_Unload:
    debug: false
    type: task
    definitions: world
    script:
    - flag <[world]> dd_sections:!
    - flag <[world]> dd_sectionData:!