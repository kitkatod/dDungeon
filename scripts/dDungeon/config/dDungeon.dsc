dd_Config:
    debug: false
    type: data
    #Version number for dDungeon Scripts
    #This will change as new updates are out of dev
    dd_version: 1.1
    #Version number for data format of saved Schematics.
    #This should only change when there is a breaking data structure change for schematics. Should be RARE.
    #Will be tagged to schematics as they are saved.
    dd_schematic_data_version: 1.0

    #If true, dDungeon validation will run after every Denizen script reload (using /ex reload)
    #You can manually run the Validation using /ddValidate
    #Defaults to false if missing
    validate_config_on_reload: false

    #Settings used by scripts to hide/show debugging information
    debugging:
        #Whether to output to user creating a dungeon when Schematic Placement Validation Fails for a specific reason
        #Will also output validations to console log
        #This can be helpful when trying to determine why a section is not being placed
        #This is a bit spammy... Don't normally keep this enabled

        #Checks whether section has been placed "enough" times in the dungeon per the section's configuration
        output_failed_validation_max_occurrences: false
        #Checks whether the connecting pathway allows incoming connections
        output_failed_validation_pathway_allows_incoming: false
        #Checks whether the placed section would be outside the defined area for the dungeon
        #(Prevents massively sprawling dungeons when not necessary)
        output_failed_validation_within_world: false
        #Checks whether the pathways connecting are facing opposite directions like they should
        output_failed_validation_matching_pathway: false
        #Checks whether each pathway in the NEXT section has a bit of space in front of it
        #(Prevents situations where hallways might run into a random wall)
        output_failed_validation_next_pathways: false
        #Checks whether each block of the new section would be placed on either AIR, or an exactly matching material
        #(Will not fail if stone is placed on stone, ladder on ladder if the direction matches, etc.)
        output_failed_validation_overlapping: false
