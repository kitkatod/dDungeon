dd_SpawnerEditor_SetBossbarColor:
    debug: false
    type: task
    definitions: loc|clickableGroupId
    data:
        ValidBossbarColors:
        - BLUE
        - GREEN
        - PINK
        - PURPLE
        - RED
        - WHITE
        - YELLOW
    script:
    #Cancel out clickable group if one is set
    - if <[clickableGroupId].if_null[no_value]> != no_value:
        - run dd_Clickable_CancelGroup def.groupId:<[clickableGroupId]>

    - narrate "<n><blue><italic> *** Enter a COLOR for this Spawner's Bossbar.<n>     Can be any of: <script.data_key[data.ValidBossbarColors].comma_separated>"
    - flag <player> dd_SpawnerEditor_SetBossbarColor:<[loc]> expire:1m


dd_SpawnerEditor_SetBossbarColor_Events:
    debug: false
    type: world
    events:
        on player chats flagged:dd_SpawnerEditor_SetBossbarColor:
        - define loc <player.flag[dd_SpawnerEditor_SetBossbarColor]>
        - define value <context.message>
        - determine cancelled passively

        #Give error message, or set value
        - if !<script[dd_SpawnerEditor_SetBossbarColor].data_key[data.ValidBossbarColors].contains[<[value]>]>:
            - narrate "<red><italic> *** Invalid Bossbar Color entered (Value: <[value]>)"
        - else:
            - flag <player> dd_SpawnerEditor_SetBossbarColor:!
            - flag <[loc]> dd_spawner.bossbar_color:<[value]>

        - narrate "<blue><italic> *** Spawner's Bossbar Color Value Set: <reset><gold><[value]>"
        - wait 10t
        - run dd_SpawnerEditor_MainMenu def.loc:<[loc]>