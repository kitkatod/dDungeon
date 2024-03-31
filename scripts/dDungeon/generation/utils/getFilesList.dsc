dd_GetFilesList:
    debug: false
    type: procedure
    definitions: category|sectionType
    script:
    - define path <[category]>/<[sectionType]>
    - if !<util.has_file[schematics/dDungeon/<[path]>]>:
        - determine <list[]>
    - define files <util.list_files[schematics/dDungeon/<[path]>]>
    - if <[files].is_empty>:
        - determine <[files]>
    - define files <[files].random[<[files].size>]>
    - define output <list[]>
    - foreach <[files]> as:file:
        - if <[file].starts_with[.]>:
            - foreach next
        - if !<[file].ends_with[.schem]>:
            - foreach next
        - define output:->:<[path]>/<[file].replace_text[.schem]>
    - determine <[output]>



dd_GetRandomizedSectionList:
    debug: false
    type: procedure
    definitions: world|category|sectionType
    script:
    #Get type data
    - define typeData <[world].flag[dd_sections.<[category]>.<[sectionType]>]>

    #Get a list of section groups and their individual weights
    - define nameGroupWeights <list[]>
    - foreach <[typeData.nameGroups]> as:nameGroup:
        - define nameGroupWeights:->:<[typeData.<[nameGroup]>]>

    #Sort list by target weights ascending
    - define nameGroupWeights <[nameGroupWeights].sort_by_value[weight_target]>

    #Get weight sum for the type
    - define sumWeight <[typeData.total_weight]>

    #Start an output list of files
    - define outputList <list[]>

    #Start randomly selecting nameGroups
    - while !<[nameGroupWeights].is_empty>:
        #If we somehow got bad data here and are looping forever then just kill the loop
        #TODO - figure out wth this is happening... Bad data in a schematic somewhere? It's rare that it pops up...
        - if <[loop_index]> >= 100:
            - debug ERROR "Infinite loop hit in generating file list. Category:<[category]> Type:<[sectionType]>"
            - while stop
        - define rnd <util.random.decimal[0].to[<[sumWeight]>]>
        - define pickedNameGroup _nopick_
        - foreach <[nameGroupWeights]> as:cNameGroup:
            #If we've already picked, bump remaining weights down by the weight of the name selected (to avoid increasing odds for other names)
            - if <[pickedNameGroup]> != _nopick_:
                - define cNameGroup.weight_target:-:<[pickedNameGroup.weight]>
            #If random value is lower than the target weight, pick this item
            - else if <[cNameGroup.weight_target]> >= <[rnd]>:
                #Save picked item
                - define pickedNameGroup <[cNameGroup]>
                #Decrease sumWeight
                - define sumWeight:-:<[pickedNameGroup.weight]>
                #Save file names to output (pick a random order from the sublist)
                - foreach <[cNameGroup.names].random[<[cNameGroup.names].size>]> as:fileName:
                    - define outputList:->:<[fileName]>
        #Remove the picked name from the list
        - define nameGroupWeights:<-:<[pickedNameGroup]>

    - determine <[outputList]>