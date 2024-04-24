dd_SetupAttributeModifiers:
    debug: false
    type: task
    definitions: world
    script:
    - define playerAttributes <[world].flag[dd_dungeonsettings.player_attributes].if_null[null]>
    - if <[playerAttributes]> == null:
        - stop

    #Set a random UUID on each attribute entry
    - foreach <[playerAttributes]> as:attributeData key:attributeKey:
        - define newAttributeList <list[]>
        - foreach <[attributeData]> as:attribute:
            - define attributeMap <[attribute].parsed>
            - define attributeMap.id <util.random_uuid>
            - define newAttributeList:->:<[attributeMap]>

        - define playerAttributes.<[attributeKey]> <[newAttributeList]>

    - flag <[world]> dd_dungeonSettings.player_attributes:<[playerAttributes]>