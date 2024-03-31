dd_ToolSwap_Events:
    debug: false
    type: world
    events:
        on player swaps items offhand:item_flagged:dd_toolswap_nexttool:
        #Don't actually swap hands
        - determine cancelled passively

        #Get the next tool in the cycle
        - define newItem <context.offhand.flag[dd_toolswap_nexttool]>

        #If player is sneaking and there's a "previous" tool, cycle to that instead
        - if <player.is_sneaking> && <context.offhand.has_flag[dd_toolswap_previoustool]>:
            - define newItem <context.offhand.flag[dd_toolswap_previoustool]>

        #Replace item in hand
        - inventory set slot:hand origin:<[newItem]>