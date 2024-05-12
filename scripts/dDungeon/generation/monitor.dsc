dd_Create_MonitorGeneration:
    debug: false
    type: task
    definitions: world|players
    script:
    - sidebar set "title:<gold>Generation Processing" players:<[players]>
    - while <[world].flag[dd_generationRunning].if_null[false]>:
        - sidebar set_line scores:0 values:<red><[world].flag[dd_currentGenerationStep].if_null[]> players:<[players]>
        - sidebar set_line scores:-1 "values:<gold><util.time_now.duration_since[<[world].flag[dd_startTime]>].formatted> <reset>elapsed" players:<[players]>
        - sidebar set_line scores:-2 "values:<gold><[world].flag[dd_loadedSchematics].size.if_null[0]> <reset>Schematics Loaded" players:<[players]>
        - sidebar set_line scores:-3 "values:<gold><[world].flag[dd_pathway_queue].size.if_null[0]> <reset>Pathways Queued" players:<[players]>
        - sidebar set_line scores:-4 "values:<gold><[world].flag[dd_inventory_queue].size.if_null[0]> <reset>Inventories Queued" players:<[players]>
        - sidebar set_line scores:-5 "values:<gold><[world].flag[dd_sectionCount].if_null[0]> <reset>Sections Placed" players:<[players]>
        - sidebar set_line scores:-6 "values:<gold><[world].flag[dd_inventoryCount].if_null[0]> <reset>Inventories Rolled" players:<[players]>
        - sidebar set_line scores:-7 "values:<gold><server.recent_tps.first.round_to_precision[0.01]> <reset>TPS" players:<[players]>
        - wait 10t

    - sidebar set_line scores:0 "values:<green>Generation Complete" players:<[players]>

    #Keep updating TPS until we close the sidebar
    - repeat 60:
        - sidebar set_line scores:-7 "values:<gold><server.recent_tps.first.round_to_precision[0.01]> <reset>TPS" players:<[players]>
        - wait 1s
    - sidebar remove players:<[players]>