dd_ReloadSectionFlags:
    debug: false
    type: task
    definitions: optionsLoc
    script:
    - define sectionOptions <[optionsLoc].flag[dd_SectionOptions]>
    - foreach <[sectionOptions.flags].if_null[<map[]>]> as:offsetData key:offset:
        - foreach <[offsetData].if_null[<map[]>]> as:flag_data key:flag_name:
            - define flagLoc <[optionsLoc].add[<[offset]>]>
            - flag <[flagLoc]> <[flag_name]>:<[flag_data]>
