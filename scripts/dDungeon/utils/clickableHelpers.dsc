dd_Clickable_AddToGroup:
    debug: false
    type: task
    definitions: groupId|clickableId
    script:
    - flag server clickableGroup.<[groupId]>:->:<[clickableId]>

dd_Clickable_CancelGroup:
    debug: false
    type: task
    definitions: groupId
    script:
    - define clickableIds <server.flag[clickableGroup.<[groupId]>].if_null[<list[]>]>
    - foreach <[clickableIds]> as:clickableId:
        - clickable cancel:<[clickableId]>
    - flag server clickableGroup.<[groupId]>:!

dd_Clickable_ServerStart:
    debug: false
    type: world
    events:
        after server start:
        - flag server clickableGroup:<map[]>


dd_Clickable_Teleport:
    debug: false
    type: task
    definitions: loc
    script:
    - teleport <[loc]>