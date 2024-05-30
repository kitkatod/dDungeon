dd_Generation_TransofrmationPermutations:
    debug: false
    type: procedure
    definitions: pathVector[Vector of the existing pathway]|incomingPathways[List of pathway directions on the test section]
    script:
    #Return list of tramsformation combinations possible
    - define outputList <list[]>

    #Special checks for up/down paths
    - if <[pathVector].y> > 0 && <[incomingPathways].contains[<location[0,-1,0]>]>:
        - foreach <list[true|false]> as:flip:
            - foreach <static[<proc[dd_Generation_TransformationPermutations_Rotations]>]> as:rotationData:
                - definemap transformation flip:<[flip]> angle:<[rotationData.angle]> radians:<[rotationData.radians]>
                - define outputList:->:<[transformation]>
    - else if <[pathVector].y> < 0 && <[incomingPathways].contains[<location[0,1,0]>]>:
        - foreach <list[true|false]> as:flip:
            - foreach <static[<proc[dd_Generation_TransformationPermutations_Rotations]>]> as:rotationData:
                - definemap transformation flip:<[flip]> angle:<[rotationData.angle]> radians:<[rotationData.radians]>
                - define outputList:->:<[transformation]>
    - else if <[pathVector].y.round> != 0:
        #If Y is not zero and there isn't a matching pathway just return nothing
        - determine <[outputList]>
    - else:
        # - debug LOG <[incomingPathways]>
        - foreach <list[true|false]> as:flip:
            - foreach <static[<proc[dd_Generation_TransformationPermutations_Rotations]>]> as:rotationData:
                - define testVector <[pathVector]>
                - if <[flip]>:
                    - define testVector <[testVector].with_z[<[testVector].z.mul[-1]>]>
                - define testVector <[testVector].rotate_around_y[<[rotationData.radians]>].round>

                # - debug LOG "<[pathVector]> - <[flip]> - <[rotationData.angle]> - <[testVector]>"

                - if <[incomingPathways].contains[<[testVector].mul[-1].round>]>:
                    - definemap transformation flip:<[flip]> angle:<[rotationData.angle]> radians:<[rotationData.radians]>
                    - define outputList:->:<[transformation]>
        # - debug LOG "<[pathVector]> - <[outputList]>""

    - determine <[outputList]>


dd_Generation_TransformationPermutations_Rotations:
    debug: false
    type: procedure
    script:
    - define out <list[]>
    - foreach <list[0|90|180|270]> as:angle:
        - definemap entry angle:<[angle]> radians:<[angle].to_radians.mul[-1]>
        - define out:->:<[entry]>
    - determine <[out]>