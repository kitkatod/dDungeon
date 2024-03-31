dd_DungeonEntranceEditor_CreateNewEntrance:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - flag <[loc]> dd_entrance:<map[]>

    #If entrance block is part of a double-block structure (door/chest/etc.), flag the second block to point to the main one.
    - define otherBlock <[loc].other_block.if_null[null]>
    - if <[otherBlock]> != null && <[otherBlock]> !matches <[loc]>:
        - flag <[otherBlock]> dd_entrance_otherblock:<[loc]>

    - narrate "<n><blue><italic> *** Entrance created."
    - wait 10t
    - run dd_DungeonEntranceEditor_SetDungeonKey def.loc:<[loc]>

