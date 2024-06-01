dd_Generation_ReportSectionCounts:
    debug: false
    type: task
    definitions: world
    script:
    - if !<[world].exists>:
        - stop
    - if !<[world].has_flag[dd_section_counter]>:
        - stop

    - define dataList <list[]>

    - foreach <[world].flag[dd_section_counter]> key:category as:categoryData:
        - foreach <[categoryData]> key:type as:typeData:
            - foreach <[typeData]> key:sectionName as:sectionData:
                - definemap data success:<[sectionData.success_count].if_null[0]> fail:<[sectionData.fail_count].if_null[0]> category:<[category]> type:<[type]> name:<[sectionName]>
                - define dataList:->:<[data]>


    - foreach <[dataList].filter_tag[<[filter_value.success].is_more_than[0]>].sort_by_value[get[name]]> as:data:
        - define msg "Success:<[data.success]> Fail:<[data.fail]> Section:<[data.category]>/<[data.type]>/<[data.name]>"
        - debug LOG "[dDungeon] <[msg]>"

    - debug LOG "[dDungeon] Below sections always failed validation"
    - foreach <[dataList].filter_tag[<[filter_value.success].equals[0]>].sort_by_value[get[name]]> as:data:
        - define msg "Success:<[data.success]> Fail:<[data.fail]> Section:<[data.category]>/<[data.type]>/<[data.name]>"
        - debug LOG "[dDungeon] <[msg]>"

    - define reportServerUrl <script[dd_Config].data_key[report_server_url].parsed.if_null[null]>
    - if <[reportServerUrl]> != null:
        - definemap webData BeginDateTime:<[world].flag[dd_startTime].format[yyyy-MM-dd hh:mm:ss].replace[ ].with[T]> EndDateTime:<util.time_now.format[yyyy-MM-dd hh:mm:ss].replace[ ].with[T]> Sections:<[dataList]>
        - define url <[reportServerUrl]>/GenerationData/LogData?serverId=<server.flag[dd_server_id]>&generationId=<[world].flag[dd_generation_id]>
        - webget <[url]> method:POST data:<[webData].to_json> save:webcall headers:<map[content-type=application/json]>

