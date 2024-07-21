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

        #List of height/widths of sections in each type. Will be used to determine a validation area size for proc[dd_Validate_NextPathways]
        - define typeHeights <list[]>
        - define typeMinWidths_Up <list[]>
        - define typeMinWidths_Down <list[]>
        - define typeMinWidths_Flat <list[]>

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


            #Get MinWidths and Hight for section based on if the section has an up/down/horizontal facing incoming pathway connection
            - define hasUp false
            - define hasDown false
            - define hasStraight false

            - if <[sectionOptions.pathway_directions].filter_tag[<[filter_value].y.is_more_than[0]>].any>:
                - define hasUp true
            - if <[sectionOptions.pathway_directions].filter_tag[<[filter_value].y.is_less_than[0]>].any>:
                - define hasDown true
            - if <[sectionOptions.pathway_directions].filter_tag[<[filter_value].y.equals[0]>].any>:
                - define hasStraight true

            - if <[hasUp]> || <[hasDown]> || <[hasStraight]>:
                - define typeHeights:->:<[sectionOptions.height].if_null[0]>
            - if <[hasUp]>:
                - define typeMinWidths_Up:->:<[sectionOptions.min_width].if_null[0]>
            - if <[hasDown]>:
                - define typeMinWidths_Down:->:<[sectionOptions.min_width].if_null[0]>
            - if <[hasStraight]>:
                - define typeMinWidths_Flat:->:<[sectionOptions.min_width].if_null[0]>

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

        #Determine target validation size for up/down/horizontal pathways in this section type
        #1: Order Lists
        #2: Pick a value that will cover enough schematics in this type
        - define typeHeights <[typeHeights].numerical>
        - define typeMinWidths_Up <[typeMinWidths_Up].numerical>
        - define typeMinWidths_Down <[typeMinWidths_Down].numerical>
        - define typeMinWidths_Flat <[typeMinWidths_Flat].numerical>

        - flag <[world]> dd_sections.<[category]>.<[type]>.pathway_validation_height:<[typeHeights].get[<[typeHeights].size.mul[0.5].round_up.if_null[0]>].if_null[6]>
        - flag <[world]> dd_sections.<[category]>.<[type]>.pathway_validation_width_up:<[typeMinWidths_Up].get[<[typeMinWidths_Up].size.mul[0.5].round_up.if_null[0]>].if_null[3]>
        - flag <[world]> dd_sections.<[category]>.<[type]>.pathway_validation_width_down:<[typeMinWidths_Down].get[<[typeMinWidths_Down].size.mul[0.5].round_up.if_null[0]>].if_null[3]>
        - flag <[world]> dd_sections.<[category]>.<[type]>.pathway_validation_width_flat:<[typeMinWidths_Flat].get[<[typeMinWidths_Flat].size.mul[0.5].round_up.if_null[0]>].if_null[6]>


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