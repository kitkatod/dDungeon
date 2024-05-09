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

    - adjust <queue> linked_player:<[user]>

    #Check if user already has an options block selected. Show it as a beacon if so
    - if <[optionsLoc]> != not_selected:
        - define optionsData <[optionsLoc].flag[dd_SectionOptions].if_null[not_selected]>
        - if <[user].world> = <[optionsLoc].world>:
            #Show options block as a beacon
            - if <[user].location.distance[<[optionsLoc]>]> <= 50 && <[showSectionOptions]>:
                #Show options block
                - define nearbyOptionsBlocks:<-:<[optionsLoc]>
                - showfake beacon <[optionsLoc]> d:3.25s
                - fakespawn block_display[material=beacon;glowing=true;glow_color=blue;scale=1.02,1.02,1.02] <[optionsLoc]> d:3.25s
                - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[optionsLoc]> "def.title:<bold><gold>Selected Section Options"

            - if <[showPathways]>:
                - foreach <[optionsData.pathways].keys.if_null[<list[]>]> as:locOffset:
                    - define pathData <[optionsData.pathways.<[locOffset]>]>
                    - define pathOptionsLoc <[optionsLoc].add[<[locOffset].proc[dd_KeyToLocation]>]>
                    - define pathLoc <[pathOptionsLoc].add[<[pathData.direction].proc[dd_KeyToLocation]>]>
                    - fakespawn block_display[material=yellow_stained_glass;glowing=true;glow_color=yellow;scale=1.02,1.02,1.02] <[pathOptionsLoc]> duration:3.25s
                    - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[pathOptionsLoc]> def.title:<bold><yellow>Pathway
                    - fakespawn block_display[material=glass;glowing=true;scale=1.02,1.02,1.02] <[pathLoc]> duration:3.25s

            - if <[showInventories]>:
                - foreach <[optionsData.inventories].keys.if_null[<list[]>]> as:locOffset:
                    - define invData <[optionsData.inventories.<[locOffset]>]>
                    - define invLoc <[optionsLoc].add[<[locOffset].proc[dd_KeyToLocation]>]>
                    - fakespawn block_display[material=yellow_stained_glass;glowing=true;glow_color=yellow;scale=1.02,1.02,1.02] <[invLoc]> duration:3.25s
                    - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[invLoc]> def.title:<bold><yellow>Inventory

            - if <[optionsData.entrancePoint].exists>:
                - fakespawn block_display[material=green_stained_glass;glowing=true;glow_color=green;scale=1.02,1.02,1.02] <[optionsLoc].add[<[optionsData.entrancePoint]>].sub[0.5,0,0.5]> d:3.25s
                - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[optionsLoc].add[<[optionsData.entrancePoint]>]> "def.title:<bold><green>Dungeon Entrance Spawn Point"

    - if <[showDungeonEntrances]>:
        - foreach <[user].location.find_blocks_flagged[dd_entrance].within[20]> as:block:
            - fakespawn block_display[material=green_stained_glass;glowing=true;glow_color=green;scale=1.02,1.02,1.02] <[block].round_down> d:3.25s
            - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[block]> "def.title:<bold><green>Active Dungeon Entrance"

    - if <[showFakeBlocks]>:
        - foreach <[user].location.find_blocks_flagged[dd_fakeBlock].within[20]> as:block:
            - fakespawn block_display[material=white_stained_glass;glowing=true;glow_color=white;scale=1.02,1.02,1.02] <[block].round_down> d:3.25s
            - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[block]> "def.title:<bold><black>Fake Block"

    - if <[showSectionOptions]>:
        - foreach <[nearbyOptionsBlocks]> as:block:
            - showfake bedrock <[block]> d:3.25s
            - fakespawn block_display[material=bedrock;glowing=true;glow_color=black;scale=1.02,1.02,1.02] <[block]> d:3.25s
            - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[block]> "def.title:<bold><dark_blue>Section Options"

    - if <[showSpawnPoints]>:
        - foreach <[user].location.find_blocks_flagged[dd_spawner].within[20]> as:block:
            - if <[block].flag[dd_spawner.spawn_table]> == NULL_TABLE:
                - define glowColor red
                - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[block]> "def.title:<bold><red>Spawn Blocker"
            - else:
                - define glowColor green
                - run dd_ShowSectionBlocks_SpawnMarkerTitle def.markerBlock:<[block]> def.title:<bold><green>Spawner
            - fakespawn block_display[material=spawner;glowing=true;glow_color=<[glowColor]>;scale=1.02,1.02,1.02] <[block].round_down> d:3.25s