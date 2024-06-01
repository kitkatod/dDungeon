## WARNING: This should ***NOT*** be used normally.
##          The only reason this exists is to mass-update schematic data because the data structure changed for some reason.
##          ***
##          This process is not quick, and involves creating/destroying a world for every schematic.
##          It is however quicker than manually recreating dungeon sections/schematics, which is why it exists at all.
##          ***
##          It's probably wise to take a backup of the "/plugins/Denizen/schematics/dDungeon" directory before running this.
dd_ResaveAllSchematics:
    debug: false
    type: task
    script:
    #Get list of all files
    - define fileList <list[]>
    - foreach <util.list_files[schematics/dDungeon/]> as:category:
        - if <[category].starts_with[_]>:
            - foreach next
        - foreach <util.list_files[schematics/dDungeon/<[category]>/]> as:type:
            - if <[type].starts_with[_]>:
                - foreach next
            - foreach <proc[dd_GetFilesList].context[<[category]>|<[type]>]> as:file:
                - define fileList:->:<[file]>

    - narrate "<blue>[dDungeon] Processing <[fileList].size> files..."

    #Load each schematic and resave it
    - while !<[fileList].is_empty>:
        #Get next file
        - define file <[fileList].first>
        - define fileList:<-:<[file]>
        - narrate "<n><blue>[dDungeon] *** <[file]>"

        #Create a temporary world for the schematic
        - define worldName tmp_fixerworld_<util.random_uuid.replace[-]>
        - createworld <[worldName]> generator:denizen:void
        #Wait until it has loaded
        - waituntil <server.worlds.parse_tag[<[parse_value].name>].contains[<[worldName]>]> max:30s rate:10t

        #Prepare world
        - define world <world[<[worldName]>]>
        - define loc <location[0,64,0,0,0,<[worldName]>]>
        - ~run dd_LoadAreaChunks def:<[loc].chunk>|8|10s

        #Load the schematic and paste it in the world
        - ~schematic load name:tmpDungeonSpawn filename:dDungeon/<[file]>
        - ~schematic paste name:tmpDungeonSpawn <[loc]>
        - ~schematic unload name:tmpDungeonSpawn

        #Load the data saved to the YAML data file
        #This SHOULD match the data saved on the schematic origin
        - ~yaml id:tmp_template_options_yaml load:schematics/dDungeon/<[file]>.yml
        ##SectionOptions should change to SectionOptions after resave
        - define sectionOptions <yaml[tmp_template_options_yaml].read[SectionOptions]>
        - ~yaml id:tmp_template_options_yaml unload

        ##Any changes needing to be made to the section should be done here.
        ##vvvvvvvvvv

        #Rename map key due to typo
        - if <[sectionOptions.enterancePoint].if_null[null]> != null:
            - define sectionOptions.entrancePoint <[sectionOptions.enterancePoint]>
            - define sectionOptions.enterancePoint:!

        ##^^^^^^^^^^

        #Save data to schematic origin
        - flag <[loc]> dd_SectionOptions:<[sectionOptions]>

        #Save schematic file and YAML data file
        - ~run dd_SchematicEditor_SaveSchematic def.optionsLoc:<[loc]>

        #Cleanup the world
        - adjust <[world]> destroy

        #Wait until world is destroyed
        - waituntil <server.worlds.parse_tag[<[parse_value].name>].contains[<[worldName]>].not> max:30s rate:10t
        - narrate "<blue>[dDungeon] World Destroyed.<n>"
        - wait 10t

    #Process is done.
    - narrate "<blue>[dDungeon] All schematics have been resaved."
