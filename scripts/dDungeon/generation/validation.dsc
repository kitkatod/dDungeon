dd_Validate_MatchingPathways:
    debug: false
    type: procedure
    definitions: vector1|vector2
    script:
    - if <[vector1].round> == <[vector2].mul[-1].round>:
        - determine true
    - else:
        - determine false


# dd_Validate_MatchingHallwayType:
#     debug: false
#     type: procedure
#     definitions: existingSectionType|connectingPathHallwayType
#     script:
#     - if <[existingSectionType].starts_with[hallway_]>:
#         - define currentHallwayType <[existingSectionType].after[hallway_]>
#         - if <[currentHallwayType]> != <[connectingPathHallwayType]>:
#             - determine false
#         - else:
#             - determine true
#     - else:
#         - determine true

# dd_Validate_MatchingAllowedTypes:
#     debug: false
#     type: procedure
#     definitions: existingSectionType|allowedTypes
#     script:
#     - if <[allowedTypes].keys.if_null[<list[]>].size> == 0:
#         - determine true
#     - if <[allowedTypes].keys.if_null[<list[]>].contains[<[existingSectionType]>]>:
#         - determine true
#     - determine false



dd_Validate_SchematicPasteLocation:
    debug: false
    type: procedure
    definitions: schemName|pasteOrigin
    script:
    - define pasteOrigin <[pasteOrigin].round_down>
    - define schemOrigin <[pasteOrigin].sub[<schematic[<[schemName]>].origin>]>
    - define pasteArea <schematic[<[schemName]>].cuboid[<[pasteOrigin]>]>
    - define blocks <[pasteArea].blocks[!*air]>
    - foreach <[blocks]> as:newBlock:
        - define relativeLoc <[newBlock].sub[<[schemOrigin]>]>
        - define currentMat <schematic[<[schemName]>].block[<[relativeLoc]>]>
        #If air is already at the location, don't worry about it...
        - if <[currentMat]> matches *air:
            - foreach next
        #Check that the material types match
        - if <[currentMat].name> != <[newBlock].material.name>:
            - determine false

        - choose <[newBlock].material.name>:
            - case ladder:
                - if <[newBlock].material.direction> != <[currentMat].direction>:
                    - determine false

    - determine true

dd_Validate_NextPathways:
    debug: false
    type: procedure
    definitions: sectionData|pasteOrigin|selectedPathwayKey
    script:
    - foreach <[sectionData.pathways]> as:pathData key:offset:
        - if <[offset]> == <[selectedPathwayKey]>:
            - foreach next
        - define pathLoc <[pasteOrigin].add[<[offset]>].add[<[pathData.direction]>]>
        #Get two cuboid corners of the area "in front" of the pathway depending on direction
        - if <[pathData.direction].y> > 0:
            - define pos1 <location[3,0,3]>
            - define pos2 <location[-3,5,-3]>
        - else if <[pathData.direction].y> < 0:
            - define pos1 <location[3,0,3]>
            - define pos2 <location[-3,-5,-3]>
        - else if <[pathData.direction].x> > 0:
            - define pos1 <location[0,-2,-6]>
            - define pos2 <location[6,6,6]>
        - else if <[pathData.direction].x> < 0:
            - define pos1 <location[0,-2,-6]>
            - define pos2 <location[-6,6,6]>
        - else if <[pathData.direction].z> > 0:
            - define pos1 <location[-6,-2,0]>
            - define pos2 <location[6,6,6]>
        - else if <[pathData.direction].z> < 0:
            - define pos1 <location[-6,-2,0]>
            - define pos2 <location[6,6,-6]>

        #Check if the area in "front" of the pathways would be blocked
        - define cuboid <[pathLoc].add[<[pos1]>].to_cuboid[<[pathLoc].add[<[pos2]>]>]>
        - if !<[cuboid].blocks[!*air].is_empty>:
            - determine false

    - determine true


dd_Validate_WithinWorld:
    debug: false
    type: procedure
    definitions: sectionData|pasteOrigin
    script:
    - define cuboid <[pasteOrigin].add[<[sectionData.pos1]>].to_cuboid[<[pasteOrigin].add[<[sectionData.pos2]>]>]>
    - if <[cuboid].min.y> < -30 || <[cuboid].max.y> > 300:
        - determine false
    - determine true

