dd_ShowSectionBlocks_Events:
    debug: false
    type: world
    events:
        #Show the player nearby blocks that are flagged as section options holders
        on delta time secondly every:3:
        - define users <server.online_ops>
        - foreach <[users]> as:user:
            - ~run dd_ShowSectionBlocks_Player def.user:<[user]>

dd_ShowSectionBlocks_Player:
    debug: false
    type: task
    definitions: user
    script:
    - define showSectionOptions <[user].item_in_hand.flag[dd_show_sectionOptions].if_null[false]>
    - define showPathways <[user].item_in_hand.flag[dd_show_pathways].if_null[false]>
    - define showInventories <[user].item_in_hand.flag[dd_show_inventories].if_null[false]>
    - define showFakeBlocks <[user].item_in_hand.flag[dd_show_fakeBlocks].if_null[false]>
    - define showDungeonEntrances <[user].item_in_hand.flag[dd_show_DungeonEntranceBlock].if_null[false]>
    - define showSpawnPoints <[user].item_in_hand.flag[dd_show_spawners].if_null[false]>

    - if !<[showSectionOptions]> && !<[showPathways]> && !<[showInventories]> && !<[showFakeBlocks]> && !<[showDungeonEntrances]>:
        - stop

    - define optionsLoc <[user].flag[dd_SchematicEditor_selectedOptionsLocation].if_null[not_selected]>
    - define nearbyOptionsBlocks <[user].location.find_blocks_flagged[dd_SectionOptions].within[50].parse_tag[<[parse_value].round_down>]>

    #Check if user already has an options block selected. Show it as a beacon if so
    - if <[optionsLoc]> != not_selected:
        - define optionsData <[optionsLoc].flag[dd_SectionOptions].if_null[not_selected]>
        - if <[user].world> = <[optionsLoc].world>:
            #Show options block as a beacon
            - if <[user].location.distance[<[optionsLoc]>]> <= 50 && <[showSectionOptions]>:
                #Show options block
                - define nearbyOptionsBlocks:<-:<[optionsLoc]>
                - showfake beacon <[optionsLoc]> players:<[user]> d:4s
                - fakespawn block_display[material=beacon;glowing=true;glow_color=blue;scale=1.02,1.02,1.02] <[optionsLoc]> players:<[user]> d:4s

            - if <[showPathways]>:
                - foreach <[optionsData.pathways].keys.if_null[<list[]>]> as:locOffset:
                    - define pathData <[optionsData.pathways.<[locOffset]>]>
                    - define pathOptionsLoc <[optionsLoc].add[<[locOffset].proc[dd_KeyToLocation]>]>
                    - define pathLoc <[pathOptionsLoc].add[<[pathData.direction].proc[dd_KeyToLocation]>]>
                    - fakespawn block_display[material=yellow_stained_glass;glowing=true;glow_color=yellow;scale=1.02,1.02,1.02] <[pathOptionsLoc]> players:<[user]> duration:4s
                    - fakespawn block_display[material=glass;glowing=true;scale=1.02,1.02,1.02] <[pathLoc]> players:<[user]> duration:4s

            - if <[showInventories]>:
                - foreach <[optionsData.inventories].keys.if_null[<list[]>]> as:locOffset:
                    - define invData <[optionsData.inventories.<[locOffset]>]>
                    - define invLoc <[optionsLoc].add[<[locOffset].proc[dd_KeyToLocation]>]>
                    - fakespawn block_display[material=yellow_stained_glass;glowing=true;glow_color=yellow;scale=1.02,1.02,1.02] <[invLoc]> players:<[user]> duration:4s

            - if <[optionsData.entrancePoint].exists>:
                - fakespawn block_display[material=green_stained_glass;glowing=true;glow_color=green;scale=1.02,1.02,1.02] <[optionsLoc].add[<[optionsData.entrancePoint]>].sub[0.5,0,0.5]> players:<[user]> d:4s

    - if <[showDungeonEntrances]>:
        - foreach <[user].location.find_blocks_flagged[dd_entrance].within[20]> as:block:
            - fakespawn block_display[material=green_stained_glass;glowing=true;glow_color=green;scale=1.02,1.02,1.02] <[block].round_down> players:<[user]> d:4s

    - if <[showFakeBlocks]>:
        - foreach <[user].location.find_blocks_flagged[dd_fakeBlock].within[20]> as:block:
            - fakespawn block_display[material=white_stained_glass;glowing=true;glow_color=white;scale=1.02,1.02,1.02] <[block].round_down> players:<[user]> d:4s

    - if <[showSectionOptions]>:
        - foreach <[nearbyOptionsBlocks]> as:block:
            - showfake bedrock <[block]> players:<[user]> d:4s
            - fakespawn block_display[material=bedrock;glowing=true;glow_color=black;scale=1.02,1.02,1.02] <[block]> players:<[user]> d:4s

    - if <[showSpawnPoints]>:
        - foreach <[user].location.find_blocks_flagged[dd_spawner].within[20]> as:block:
            - if <[block].flag[dd_spawner.spawn_table]> == NULL_TABLE:
                - define glowColor red
            - else:
                - define glowColor green
            - fakespawn block_display[material=spawner;glowing=true;glow_color=<[glowColor]>;scale=1.02,1.02,1.02] <[block].round_down> players:<[user]> d:4s