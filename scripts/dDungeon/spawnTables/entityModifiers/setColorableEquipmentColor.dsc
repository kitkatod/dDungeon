dd_SpawnTables_SetColorableEquipmentColor:
    debug: false
    type: task
    definitions: entity|color
    script:
    - define equipment <[entity].equipment_map>

    - foreach <[equipment].keys> as:slot:
        - define item <[equipment.<[slot]>]>
        - if <[item].is_colorable>:
            - adjust def:item color:<[color]>
            - define equipment.<[slot]> <[item]>

    - adjust <[entity]> equipment:<[equipment]>