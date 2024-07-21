dd_Generation_ReportSectionGeneration:
    debug: false
    type: task
    definitions: world|generationData|generationSectionId
    script:
    - define reportServerUrl <script[dd_Config].data_key[report_server_url].parsed.if_null[disable]>
    - if <[reportServerUrl].starts_with[disable]>:
        - stop

    - if !<[world].exists>:
        - stop
    - if !<[world].has_flag[dd_section_counter]>:
        - stop

    - define generationId <[world].flag[dd_generation_id].if_null[null]>
    - if <[generationId]> == null:
        - stop

    - definemap webData AttemptData:<[generationData]> GenerationSectionId:<[generationSectionId]>

    - define url <[reportServerUrl]>/GenerationData/SectionPlaced?generationId=<[generationId]>
    - webget <[url]> method:POST data:<[webData].to_json[native_types=true]> save:webcall headers:<map[content-type=application/json]>


dd_Generation_ReportGenerationStart:
    debug: false
    type: task
    definitions: world|category
    script:
    - define reportServerUrl <script[dd_Config].data_key[report_server_url].parsed.if_null[disable]>
    - if <[reportServerUrl].starts_with[disable]>:
        - stop

    - if !<[world].exists>:
        - stop

    - define serverId <server.flag[dd_server_id].if_null[null]>
    - if <[serverId]> == null:
        - stop

    - define generationId <[world].flag[dd_generation_id].if_null[null]>
    - if <[generationId]> == null:
        - stop

    - definemap webData Category:<[category]> BeginDateTime:<util.time_now.format[yyyy-MM-dd hh:mm:ss.SSS].replace[ ].with[T]>

    - define url <[reportServerUrl]>/GenerationData/GenerationStarted?serverId=<[serverId]>&generationId=<[generationId]>
    - webget <[url]> method:POST data:<[webData].to_json[native_types=true]> save:webcall headers:<map[content-type=application/json]>


dd_Generation_ReportGenerationFinish:
    debug: false
    type: task
    definitions: world
    script:
    - define reportServerUrl <script[dd_Config].data_key[report_server_url].parsed.if_null[disable]>
    - if <[reportServerUrl].starts_with[disable]>:
        - stop

    - if !<[world].exists>:
        - stop

    - define serverId <server.flag[dd_server_id].if_null[null]>
    - if <[serverId]> == null:
        - stop

    - define generationId <[world].flag[dd_generation_id].if_null[null]>
    - if <[generationId]> == null:
        - stop

    - define url <[reportServerUrl]>/GenerationData/GenerationFinished?serverId=<[serverId]>&generationId=<[generationId]>&finishDateTime=<util.time_now.format[yyyy-MM-dd hh:mm:ss.SSS].replace[ ].with[T]>
    - webget <[url]> method:POST save:webcall

dd_Generation_ReportAddAttemptData:
    debug: false
    type: task
    definitions: world|type|name|angle|flipped|failReason
    script:
    - definemap data Type:<[type]> Name:<[name]> RotateAngle:<[angle]> Flipped:<[flipped]> ValidationFailReason:<[failReason]> DateTime:<util.time_now.format[yyyy-MM-dd hh:mm:ss.SSS].replace[ ].with[T]>
    - flag <[world]> dd_sectionGenerationData:->:<[data]>

dd_Generation_ReportAddPlacedData:
    debug: false
    type: task
    definitions: world|type|name|angle|flipped
    script:
    - definemap data Type:<[type]> Name:<[name]> RotateAngle:<[angle]> Flipped:<[flipped]> DateTime:<util.time_now.format[yyyy-MM-dd hh:mm:ss.SSS].replace[ ].with[T]>
    - flag <[world]> dd_sectionGenerationData:->:<[data]>