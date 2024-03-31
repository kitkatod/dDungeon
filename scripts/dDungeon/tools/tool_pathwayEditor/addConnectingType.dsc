dd_PathwayEditor_PromptAddConnectingType:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|clickableGroupId
    script:
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Click the Type you'd like to allow for this Pathway Connection"

    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    #Make sure player has an options block selected
    - define optionsData <[optionsLoc].flag[dd_SectionOptions]>

    - define typeList <util.list_files[schematics/dDungeon/<[optionsData.category]>]>
    - foreach <[typeList]> as:type:
        - clickable dd_PathwayEditor_PromptAddConnectingType_Chance def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.clickableGroupId:<[clickableGroupId]> for:<player> until:1m save:clickType
        - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickType].id>
        - narrate "<blue><italic> *** <reset><gold>[<element[<[type]>].on_click[<entry[clickType].command>]>]"

dd_PathwayEditor_PromptAddConnectingType_Chance:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|type|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<blue><italic> *** Click chance, or click Custom to set an exact number"
    - define clickableGroupId <util.random_uuid>
    - runlater dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]> delay:1m

    - clickable dd_PathwayEditor_AddConnectingType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.chance:10 def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickVeryRare
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickVeryRare].id>
    - clickable dd_PathwayEditor_AddConnectingType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.chance:50 def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickRare
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickRare].id>
    - clickable dd_PathwayEditor_AddConnectingType def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.chance:100 def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickCommon
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCommon].id>
    - clickable dd_PathwayEditor_PromptAddConnectingType_CustomChance def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.clickableGroupId:<[clickableGroupId]> usages:1 for:<player> until:1m save:clickCustom
    - run dd_Clickable_AddToGroup def.groupId:<[clickableGroupId]> def.clickableId:<entry[clickCustom].id>

    - narrate "<blue><italic> - <gold>[<element[VERY RARE].on_click[<entry[clickVeryRare].command>]> (10)]"
    - narrate "<blue><italic> - <gold>[<element[RARE].on_click[<entry[clickRare].command>]> (50)]"
    - narrate "<blue><italic> - <gold>[<element[COMMON].on_click[<entry[clickCommon].command>]> (100)]"
    - narrate " "
    - narrate "<blue><italic> - <gold><italic>[<element[CUSTOM].on_click[<entry[clickCustom].command>]> (#)]"

dd_PathwayEditor_PromptAddConnectingType_CustomChance:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|type|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <player> dd_PathwayEditor_PromptAddConnectingType_Chance.relativeLoc:<[relativeLoc]> expire:1m
    - flag <player> dd_PathwayEditor_PromptAddConnectingType_Chance.optionsLoc:<[optionsLoc]> expire:1m
    - flag <player> dd_PathwayEditor_PromptAddConnectingType_Chance.type:<[type]> expire:1m
    - narrate "<blue><italic> *** Enter a numeric chance value"

dd_PathwayEditor_PromptAddConnectingType_Chance_Chat:
    debug: false
    type: world
    events:
        on player chats flagged:dd_PathwayEditor_PromptAddConnectingType_Chance:
        - determine cancelled passively
        - define chance <context.message>
        - if !<[chance].is_decimal>:
            - narrate "<red><italic> *** Please enter a numeric chance value"
        - else:
            - define relativeLoc <player.flag[dd_PathwayEditor_PromptAddConnectingType_Chance.relativeLoc]>
            - define optionsLoc <player.flag[dd_PathwayEditor_PromptAddConnectingType_Chance.optionsLoc]>
            - define type <player.flag[dd_PathwayEditor_PromptAddConnectingType_Chance.type]>
            - run dd_PathwayEditor_AddConnectingType  def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]> def.type:<[type]> def.chance:<[chance]>
            - flag <player> dd_PathwayEditor_PromptAddConnectingType_Chance:!

dd_PathwayEditor_AddConnectingType:
    debug: false
    type: task
    definitions: relativeLoc|optionsLoc|type|chance|clickableGroupId
    script:
    - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>
    - flag <[optionsLoc]> dd_SectionOptions.pathways.<[relativeLoc]>.possible_connections.<[type]>.chance:<[chance].if_null[100]>
    - narrate "<blue><italic> *** Added Connection Type <reset><gold><[type]> <reset><blue>(Chance: <[chance]><reset><blue>)"
    - run dd_PathwayEditor_MainMenu def.relativeLoc:<[relativeLoc]> def.optionsLoc:<[optionsLoc]>