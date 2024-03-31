dd_LootTables_Events:
    debug: false
    type: world
    events:
        #Cancel and Disable picking up arrows flagged with dd_arrowNoPickup
        on player picks up launched arrow in:world_flagged:dd_DungeonSettings:
        - if !<context.item.has_flag[dd_arrowNoPickup]>:
            - stop
        - determine cancelled passively
        - adjust <context.arrow> pickup_status:DISALLOWED

        #Validate Loot Table configs on script reload
        after reload scripts:
        - run dd_LootTables_ValidateConfigs