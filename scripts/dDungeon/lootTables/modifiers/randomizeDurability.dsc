dd_LootTables_RandomizeDurability:
    debug: false
    type: procedure
    definitions: item
    script:
    #Make sure we can do something with the input, otherwise just return the input back unmodified
    - if !<[item].exists> || <[item].object_type> != item || <[item].max_durability.if_null[0]> == 0:
        - determine <[item]>


    #20% of durability set with full durability range available
    - define dur <proc[dd_TrangularDistroRandomInt].context[0|<[item].max_durability.sub[1]>].mul[0.2]>
    #80% of durability set within 70% and 100% available
    - define dur:+:<proc[dd_TrangularDistroRandomInt].context[<[item].max_durability.mul[0.7]>|<[item].max_durability.sub[1]>].mul[0.8]>
    - adjust def:item durability:<[dur].round>

    - determine <[item]>