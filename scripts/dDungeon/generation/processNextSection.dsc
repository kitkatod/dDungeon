dd_ProcessNextSection:
    debug: false
    type: task
    definitions: world
    script:
    #Get next queued pathway item
    - define pathwayQueueSettings <[world].flag[dd_pathway_queue].random>
    - flag <[world]> dd_pathway_queue:<-:<[pathwayQueueSettings]>

    #Get config settings
    - define debugConfig <script[dd_Config].data_key[debugging].if_null[<map[]>]>

    #Get objects from settings
    - define nextSectionLoc <[pathwayQueueSettings.pasteLoc]>
    - define buildVariables <[pathwayQueueSettings.buildVariables]>
    - define previousType <[pathwayQueueSettings.previousType]>
    - define pathOptions <[pathwayQueueSettings.pathOptions]>
    - define dungeonSettings <[world].flag[dd_DungeonSettings]>
    - define category <[dungeonSettings.category]>
    - define sectionCountSoftCapReached <[dungeonSettings.section_count_soft_max].if_null[450].is_less_than_or_equal_to[<[world].flag[dd_sectionCount]>]>
    - define dungeonKey <[world].flag[dd_DungeonKey].if_null[null]>

    #Make sure the area is loaded incase we move far away from the origin
    - ~run dd_LoadAreaChunks def:<[nextSectionLoc].chunk>|4|15s

    #Check if the pathway is setting the next room type
    - if !<[pathOptions.possible_connections].if_null[<map[]>].is_empty>:
        - define buildVariables.nextRoomType <[pathOptions.possible_connections]>
    #Check if the pathway resets the hallway count
    - if <[pathOptions.resetHallwayCount].if_null[false]>:
        - define buildVariables.hallwaysRemaining <util.random.int[3].to[6]>
        - define buildVariables.hallwaysRemaining:+:<util.random.int[0].to[5]>

    #Check if we need to skip hallways on the pathway
    - if <[pathOptions.hallwayType].if_null[default]> == skip_hallway:
        - define buildVariables.hallwaysRemaining 0
    - else:
        - define buildVariables.hallwayType <[pathOptions.hallwayType].if_null[default]>


    #List of section types we could place here
    - define possibleTypes <list[]>

    #Check if soft cap is reached
    - if !<[sectionCountSoftCapReached]>:
        #Check if we need to build a hallway next
        - if <[buildVariables.hallwaysRemaining]> > 0:
            - define possibleTypes:->:hallway_<[buildVariables.hallwayType]>
            # # - define possibleTypes:->:hallway_<[pathOptions.hallwayType].if_null[default]>
        #If not, build whatever the NextRoomType calls for
        - else if <[buildVariables.nextRoomType].if_null[<map[]>].is_empty>:
            - announce "<red> [dDungeon] ERROR - NextRoomType not set. This usually means a Spawn Room had a pathway which doesn't set a <&dq>Next Section Type<&dq>" to_ops
            - debug ERROR "[dDungeon] Generation Error - [buildVariables.nextRoomType] is not set when it is needed. This usually indicates the Spawn Room has a pathway without setting a <&dq>Next Section Type<&dq>."
            - stop
        - else:
            - foreach <[buildVariables.nextRoomType].proc[dd_Pathways_RandomWeightedOrder]> as:type:
                - define possibleTypes:->:<[type]>
            #After the normal "targeted" types, add in a hallway... Would rather a hallway be placed than a deadend later. Maybe we can place the actual target room "next" section
            #Don't do this though if we've placed "too many" "extra" hallways. Need to stop at some point (or you end up with a hallway that never ends...)
            #Stop after 5 "extra" hallways
            - if <[buildVariables.hallwaysRemaining]> > -5:
                - define possibleTypes:->:hallway_<[buildVariables.hallwayType]>
                # # - if <[pathOptions.hallwayType].if_null[default]> == skip_hallway:
                # #     - define possibleTypes:->:hallway_default
                # # - else:
                # #     - define possibleTypes:->:hallway_<[pathOptions.hallwayType].if_null[default]>

    # Put a deadend option at the end
    # If we can't place SOMETHING, at least we can try to block off the giant hole in the wall...
    - define possibleTypes:->:deadend_<[buildVariables.hallwayType]>

    #Try each targeted possible section types in the order given
    - define sectionFound false

    #We know what sections we want to try to place in terms of preference
    #Go through each section type and find what will work
    - while !<[possibleTypes].is_empty> && !<[sectionFound]>:
        - define targetType <[possibleTypes].first>
        - define possibleTypes:<-:<[targetType]>


        #Get file names for the selected section type
        - define possibleSections <proc[dd_GetRandomizedSectionList].context[<[world]>|<[category]>|<[targetType]>]>

        #Validate placement of each file. If it has a conflict with what has already been placed,
        #skip it and try another
        - while !<[possibleSections].is_empty> && !<[sectionFound]>:
            - define targetSection <[possibleSections].first>
            - define possibleSections:<-:<[targetSection]>
            - define targetSectionSchemPath <[category]>/<[targetType]>/<[targetSection]>

            # - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
            # - narrate "Trying <[targetType]>, <[targetSection]> at <gold><element[LOC].on_click[<entry[clickLoc].command>]>"

            #Check if the previous section was the exact same file - if so, skip it
            - if <[buildVariables.lastSuccessful]||null> == <[targetSection]> && <[previousType]||null> == <[targetType]>:
                - while next

            #Load the schematic's data file (not the schematic yet)
            - define schemOptions <[world].flag[dd_sectionData.<[category]>.<[targetType]>.<[targetSection]>]>

            #Check things that don't involve loading the schematic (for speeeeed)
            #Check max per dungeon counts
            - define sectionMaxCount <[schemOptions.maxOccurrenceCount].if_null[-1]>
            - if <[sectionMaxCount]> > -1:
                - define currentCount <[world].flag[dd_sections.<[category]>.<[targetType]>.<[schemOptions.nameGroup]>.occurrences]>
                - if <[currentCount]> >= <[sectionMaxCount]>:
                    - if <[debugConfig.output_failed_validation_max_occurrences]>:
                        - narrate "(name:<[schemOptions.name]>) Failed: reached max occurrences"
                        - debug LOG "(dDungeon) (name:<[schemOptions.name]>) Failed: reached max occurrences"
                    - while next

            #Try different flipping/rotating. Randomize to add variance
            - define flipList <list[false|true].random[2]>
            - while !<[flipList].is_empty> && !<[sectionFound]>:
                - define flip <[flipList].first>
                - define flipList:<-:<[flip]>

                - define rotationList <list[0|90|180|270].random[4]>
                - while !<[rotationList].is_empty> && !<[sectionFound]>:
                    - define rotate <[rotationList].first>
                    - define rotationList:<-:<[rotate]>

                    - define testOptions <[schemOptions]>
                    - if <[flip]>:
                        - define testOptions <[testOptions].proc[dd_Transform_FlipOverX]>
                    - define testOptions <[testOptions].proc[dd_Transform_RotateAroundY].context[<[rotate]>]>

                    #Try to determine if one of the pathways will work
                    - define testPathwaysList <[testOptions.pathways].keys>
                    - while !<[testPathwaysList].is_empty> && !<[sectionFound]>:
                        - define testPathwayKey <[testPathwaysList].first>
                        - define testPathwaysList:<-:<[testPathwayKey]>
                        - define testPathwayOptions <[testOptions.pathways.<[testPathwayKey]>]>

                        #PasteLoc would be the origin of this schematic
                        - define pasteLoc <[nextSectionLoc].sub[<[testPathwayKey]>]>

                        - if !<[testPathwayOptions.allowIncoming].if_null[true]>:
                            - if <[debugConfig.output_failed_validation_pathway_allows_incoming]>:
                                - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
                                - narrate "(name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Pathway allows incoming<reset> ([<element[TP TO LOC].on_click[<entry[clickLoc].command>].on_hover[<[nextSectionLoc]>]>])"
                                - debug LOG "(dDungeon) (name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Pathway allows incoming (<[nextSectionLoc]>)"
                            - while next

                        - if !<[testOptions].proc[dd_Validate_WithinWorld].context[<[pasteLoc]>]>:
                            - if <[debugConfig.output_failed_validation_within_world]>:
                                - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
                                - narrate "(name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Within World Check<reset> ([<element[TP TO LOC].on_click[<entry[clickLoc].command>].on_hover[<[nextSectionLoc]>]>])"
                                - debug LOG "(dDungeon) (name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Within World Check (<[nextSectionLoc]>)"
                            - while next

                        - if !<[pathOptions.direction].proc[dd_Validate_MatchingPathways].context[<[testPathwayOptions.direction]>]>:
                            - if <[debugConfig.output_failed_validation_matching_pathway]>:
                                - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
                                - narrate "(name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Matching Pathways ([<element[TP TO LOC].on_click[<entry[clickLoc].command>].on_hover[<[nextSectionLoc]>]>])"
                                - debug LOG "(dDungeon) (name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Matching Pathways (<[nextSectionLoc]>)"
                            - while next

                        - if !<[testOptions].proc[dd_Validate_NextPathways].context[<[pasteLoc]>|<[testPathwayKey]>]>:
                            - if <[debugConfig.output_failed_validation_next_pathways]>:
                                - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
                                - narrate "(name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Next Pathways Check<reset> ([<element[TP TO LOC].on_click[<entry[clickLoc].command>].on_hover[<[nextSectionLoc]>]>])"
                                - debug LOG "(dDungeon) (name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Next Pathways Check (<[nextSectionLoc]>)"
                            - while next

                        # - if !<[previousType].proc[dd_Validate_MatchingHallwayType].context[<[testPathwayOptions.hallwayType].if_null[default]>]>:
                        #     - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
                        #     - narrate "(name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Hallway Type Match<reset> ([<element[TP TO LOC].on_click[<entry[clickLoc].command>]>])"
                        #     - while next

                        #Validations up until this point did not require the schematic to be loaded
                        #Load the schematic and run further validations
                        #Flip/Rotate as needed to match previous operations
                        - ~run dd_Schematic_SetOrientation def.schemPath:<[targetSectionSchemPath]> def.flip:<[flip]> def.rotation:<[rotate]>

                        - if !<proc[dd_Validate_SchematicPasteLocation].context[<[targetSectionSchemPath]>|<[pasteLoc]>]>:
                            - if <[debugConfig.output_failed_validation_overlapping]>:
                                - clickable dd_Clickable_Teleport def.loc:<[nextSectionLoc]> until:10m save:clickLoc
                                - narrate "(name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Overlapping Failure ([<element[TP TO LOC].on_click[<entry[clickLoc].command>].on_hover[<[nextSectionLoc]>]>])"
                                - debug LOG "(dDungeon) (name:<[testOptions.name]> flip:<[flip]> rotate:<[rotate]>) Failed: Overlapping Failure (<[nextSectionLoc]>)"
                            - ~run dd_Schematic_UndoOrientation def.schemPath:<[targetSectionSchemPath]> def.flip:<[flip]> def.rotation:<[rotate]>
                            - while next


                        #Wooooo!
                        - define sectionFound true
                        - define buildVariables.lastSuccessful <[targetSection]>

                        #Get the cuboid of the placed area
                        - define cuboid <[pasteLoc].add[<[testOptions.pos1]>].to_cuboid[<[pasteLoc].add[<[testOptions.pos2]>]>]>
                        - adjust <cuboid[<[world].name>_dcarea]> add_member:<[cuboid]>

                        #Increment the occurrence count of this section
                        - flag <[world]> dd_sections.<[category]>.<[targetType]>.<[testOptions.nameGroup]>.occurrences:++

                        #Knock down the count of hallways to place if we placed a hallway
                        - if <[targetType].starts_with[hallway_]>:
                            - define buildVariables.hallwaysRemaining:--

                        # # - narrate "Placing section (<[targetFile]>) at <[pasteLoc]>"

                        #Paste the section
                        - ~schematic paste noair name:<[targetSectionSchemPath]> <[pasteLoc]> entities
                        - ~run dd_Schematic_UndoOrientation def.schemPath:<[targetSectionSchemPath]> def.flip:<[flip]> def.rotation:<[rotate]>

                        #Flag options block with "transformed" section options data
                        - flag <[pasteLoc]> dd_SectionOptions:<[testOptions]>
                        - flag <[pasteLoc]> dd_SectionOptions.readonly:true

                        #Reload any saved flags for the section due to flags being lost when pasting when saved to air blocks. Happens because we paste with noair set.
                        - if !<[testOptions.flags].keys.is_empty.if_null[true]>:
                            - ~run dd_ReloadSectionFlags def.optionsLoc:<[pasteLoc]>

                        #Remove this pathway from pathway options (since we just used it...)
                        - define testOptions.pathways.<[testPathwayKey]>:!

                        #Fire custom event for Section being placed
                        - definemap context area:<[cuboid]> dungeon_key:<[dungeonKey]> dungeon_category:<[category]> dungeon_section_type:<[targetType]> dungeon_section_name:<[testOptions.name]>
                        - customevent id:dd_dungeon_section_placed context:<[context]>

                        # TODO - Remove this logic in favor of just firing a Custom Event (already added)
                        # TODO -      Custom Events allow easier control as to firing multiple tasks, and switching what runs based on section type etc.
                        #Run dungeon specific custom noise generation if it is specified
                        - if <[dungeonSettings.noise_generation_task].exists>:
                            - define taskScript <[dungeonSettings.noise_generation_task].as[script].if_null[null]>
                            - if <[taskScript]> != null && <[taskScript].data_key[type]> == task:
                                - run <[taskScript]> def.cuboid:<[cuboid]> def.type:<[targetType]>

                        #Run any modifiers on section area that should always take place
                        - ~run dd_StandardSectionModifiers_SetupFakeBlocks def.area:<[cuboid]>
                        - ~run dd_StandardSectionModifiers_ChangeAirToCaveair def.area:<[cuboid]>

                        #Queue other pathways from this section
                        - ~run dd_QueuePathways def.loc:<[pasteLoc]> def.sectionOptions:<[testOptions]> def.buildVariables:<[buildVariables]>

                        #Queue inventories to be processed later
                        - ~run dd_QueueInventories def.loc:<[pasteLoc]> def.sectionOptions:<[testOptions]>
