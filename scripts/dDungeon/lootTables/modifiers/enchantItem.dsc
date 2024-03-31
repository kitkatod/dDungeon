dd_EnchantItem:
    debug: false
    type: procedure
    definitions: item|data
    script:
    - if !<[item].exists> || <[item].object_type> != item:
        - determine <[item]>

    - define enchantmentLevel <[data.enchantment_level]||null>
    - if <[enchantmentLevel]> == null:
        - define enchantmentLevelMin 1
        - define enchantmentLevelMax -1
    - else if <[enchantmentLevel].escaped.contains_all_text[&pipe]>:
        - define enchantmentLevelMin <[enchantmentLevel].before[|]>
        - define enchantmentLevelMax <[enchantmentLevel].after[|]>
    - else:
        - define enchantmentLevelMin <[enchantmentLevel]>
        - define enchantmentLevelMax <[enchantmentLevel]>

    - define enchantCount <[data.enchantment_count].if_null[1]>
    - if <[enchantCount].escaped.contains_all_text[&pipe]>:
        - define enchantCount <[enchantCount].proc[dd_TrangularDistroRandomInt]>

    - define allowCurses <[data.allow_curses]||true>

    - define allowLevelsOverMax <[data.allow_enchants_over_max].if_null[false]>

    - define disallowedEnchants <[data.disallowed_enchantments]||<list[]>>


    - define enchantments <[data.allowed_enchantments]||null>
    - if <[enchantments]> == null:
        - define enchantments <server.enchantments>

    #Randomize list
    - define enchantments <[enchantments].random[999]>

    #Start applying enchantments
    - while !<[enchantments].is_empty> && <[enchantCount]> > 0:
        #Pop next from queue
        - define enchant <[enchantments].first>
        - define enchantments:<-:<[enchant]>

        #Value can be either an enchantment or enchantment name. Force it to be an EnchantmentTag
        - define enchant <[enchant].as[enchantment]>

        #Skip if it's a curse and we're skipping curses
        - if !<[allowCurses]> && <[enchant].is_curse>:
            - while next

        #Skip if it's a disallowed enchantment
        - if <[disallowedEnchants].contains[<[enchant].name>]>:
            - while next

        - if <[enchant].can_enchant[<[item]>]> || <[item].material> matches enchanted_book:
            #If enchantment max level is 1, always select 1 (this applies to things like Mending)
            - if <[enchant].max_level> == 1:
                - define lvl 1

            - else:
                #Select a level somewhat randomly
                - define enchantMinLvl <[enchantmentLevelMin]>
                - define enchantMaxLvl <[enchantmentLevelMax]>

                #If max level is -1, fill in the max level as the enchantment max level
                - if <[enchantMaxLvl]> == -1:
                    - define enchantMaxLvl <[enchant].max_level>
                #If max level is above enchantment max level and disallowing setting above max, set max level to enchantment max level
                - else if <[enchantMaxLvl]> > <[enchant].max_level> && !<[allowLevelsOverMax]>:
                    - define enchantMaxLvl <[enchant].max_level>

                - if <[enchantMinLvl]> > <[enchant].max_level> && !<[allowLevelsOverMax]>:
                    - define enchantMinLvl <[enchant].max_level>

                - define lvl <proc[dd_TrangularDistroRandomInt].context[<[enchantMinLvl]>|<[enchantMaxLvl]>]>


            - adjust def:item enchantments:<[enchant].name>=<[lvl]>
            - define enchantCount:--

    - define item <[item].proc[dd_LootTables_FixItemEnchantmentLore]>
    - determine <[item]>