dd_SpawnTables_SetShieldDesign:
    debug: false
    type: task
    definitions: entity|base_color|patterns
    script:
    - if <[entity].item_in_hand> matches shield:
        - define item <[entity].item_in_hand>
        - adjust def:item base_color:<[base_color]>
        - adjust def:item patterns:<[patterns]>
        - adjust <[entity]> item_in_hand:<[item]>

    - if <[entity].item_in_offhand> matches shield:
        - define item <[entity].item_in_offhand>
        - adjust def:item base_color:<[base_color]>
        - adjust def:item patterns:<[patterns]>
        - adjust <[entity]> item_in_offhand:<[item]>
