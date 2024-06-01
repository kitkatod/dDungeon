dd_SchematicEditor_SaveSchematic:
    debug: false
    type: task
    definitions: optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - define optionsBlockData <[optionsLoc].flag[dd_SectionOptions]>
    - define optionsBlockData.schematic_data_version <script[dd_ValidateConfigs].data_key[data.dd_schematic_data_version].if_null[1.0]>

    - if <[optionsBlockData.readonly].if_null[false]>:
        - narrate "<red> *** Whoah!! It looks like you're trying to save a Dungeon Section that was generated as part of a Dungeon."
        - narrate "<red>     Dungeon Sections are changed during generation, so saving this section is blocked to prevent weird things happening to your schematic."
        - stop

    - define pos1 <[optionsLoc].add[<[optionsBlockData.pos1]>]>
    - define pos2 <[optionsLoc].add[<[optionsBlockData.pos2]>]>
    - define name <[optionsBlockData.name]>
    - define category <[optionsBlockData.category]>
    - define type <[optionsBlockData.type]>

    - define cuboid <[pos1].to_cuboid[<[pos2]>]>

    #Reset any previous flags that were saved
    - define optionsBlockData.flags:!

    #Get flags that need to be saved to .yml
    - foreach <script[dd_Config].data_key[schematic_copy_flags].if_null[<list[]>]> as:flag_name:
        - foreach <[cuboid].blocks_flagged[<[flag_name]>]> as:flagged_loc:
            - define offset <[flagged_loc].round.sub[<[optionsLoc]>].proc[dd_LocationToKey]>
            - define optionsBlockData.flags.<[offset]>.<[flag_name]> <[flagged_loc].flag[<[flag_name]>]>

    #Resave modified data object back to Options Location
    - flag <[optionsLoc]> dd_SectionOptions:<[optionsBlockData]>

    - ~schematic create name:<[name]> location:<[optionsLoc]> area:<[cuboid]> entities flags
    - ~schematic save name:<[name]> filename:dDungeon/<[category]>/<[type]>/<[name]>
    - ~schematic unload name:<[name]>

    - yaml create id:tmp_options
    - yaml id:tmp_options set SectionOptions:<[optionsBlockData]>
    - ~yaml savefile:schematics/dDungeon/<[category]>/<[type]>/<[name]>.yml id:tmp_options
    - yaml unload id:tmp_options

    - narrate "<blue><italic> *** Schematic <gold><[name]> <blue>Saved"