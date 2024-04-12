dd_SchematicEditor_AutoSetSectionArea:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId|returnToMainMenu
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    #Get a cuboid expanded from the options block
    - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc].context[<[optionsLoc]>]>

    #If the options block location is now air but the block under is not, start the cuboid from below the options block
    - if <[optionsLoc]> matches *air && <[optionsLoc].down[1]> !matches *air:
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc].context[<[optionsLoc].down[1]>]>

    #Pull the min/max locations
    - define pos1 <[cuboid].min>
    - define pos2 <[cuboid].max>

    #Determine relative position of min and max locations from the options block
    - define pos1 <[pos1].round.sub[<[optionsLoc]>]>
    - define pos2 <[pos2].round.sub[<[optionsLoc]>]>

    #Save data back to options block
    - flag <[optionsLoc]> dd_SectionOptions.pos1:<[pos1].proc[dd_LocationWithoutWorld]>
    - flag <[optionsLoc]> dd_SectionOptions.pos2:<[pos2].proc[dd_LocationWithoutWorld]>

    - narrate "<blue><italic> *** Section boundary been set"
    - narrate "<blue><italic>     (Note that if blocks are connected only diagonally they may not have been identified)"


    - run dd_SchematicEditor_ShowBoundary def.optionsLoc:<[optionsLoc]> def.returnToMainMenu:false

    - if <[returnToMainMenu].if_null[false]>:
        - wait 10t
        - run dd_SchematicEditor_MainMenu def.optionsLoc:<[optionsLoc]>


dd_SchematicCreator_ExpandCuboidFromLoc:
    debug: false
    type: procedure
    definitions: loc
    script:
    - define cuboid <[loc].to_cuboid[<[loc]>]>
    - define cBlocks 0

    - while <[cuboid].blocks[!air].size> != <[cBlocks]> && <[loop_index].if_null[0]> <= 40:
        - define cBlocks <[cuboid].blocks[!air].size>
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks].context[<[cuboid]>|<location[1,0,0]>]>
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks].context[<[cuboid]>|<location[-1,0,0]>]>
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks].context[<[cuboid]>|<location[0,1,0]>]>
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks].context[<[cuboid]>|<location[0,-1,0]>]>
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks].context[<[cuboid]>|<location[0,0,1]>]>
        - define cuboid <proc[dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks].context[<[cuboid]>|<location[0,0,-1]>]>

    - determine <[cuboid]>

dd_SchematicCreator_ExpandCuboidFromLoc_ExpandIfNewBlocks:
    debug: false
    type: procedure
    definitions: cuboid|direction
    script:
    - define cCount <[cuboid].blocks[!air].size>
    - define iCuboid <[cuboid].expand_one_side[<[direction]>]>
    - if <[cCount]> != <[iCuboid].blocks[!air].size>:
        - determine <[iCuboid]>
    - else:
        - determine <[cuboid]>
