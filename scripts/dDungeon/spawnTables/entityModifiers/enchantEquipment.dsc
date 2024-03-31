dd_SpawnTables_EnchantEquipment:
    debug: false
    type: task
    definitions: entity|enchantment_level|enchantment_count|allowed_enchantments|allow_curses|allow_enchants_over_max|disallowed_enchantments
    script:
    #Define a default data map
    - definemap enchantData:
        dd_EnchantItem:
            enchantment_level: 1|3
            enchantment_count: 2|4
            allowed_enchantments:
            - knockback
            - sharpness
            - protection
            - projectile_protection

    - if <[enchantment_level].exists>:
        - define enchantmentData.enchantment_level <[enchantment_level]>
    - if <[enchantment_count].exists>:
        - define enchantmentData.enchantment_count <[enchantment_count]>
    - if <[allowed_enchantments].exists>:
        - define enchantmentData.allowed_enchantments <[allowed_enchantments]>
    - if <[allow_curses].exists>:
        - define enchantmentData.allow_curses <[allow_curses]>
    - if <[allow_enchants_over_max].exists>:
        - define enchantmentData.allow_enchants_over_max <[allow_enchants_over_max]>
    - if <[disallowed_enchantments].exists>:
        - define enchantmentData.disallowed_enchantments <[disallowed_enchantments]>

    #Enchant armor
    - define equipMap <[entity].equipment_map>
    - foreach <[equipMap]> as:item key:slot:
        - define equipMap.<[slot]> <[item].proc[dd_EnchantItem].context[<[enchantData]>]>
    - adjust <[entity]> equipment:<[equipMap]>

    #Enchant hand/offhand
    - if <[entity].item_in_hand> != air:
        - adjust <[entity]> item_in_hand:<[entity].item_in_hand.proc[dd_EnchantItem].context[<[enchantData]>]>
    - if <[entity].item_in_offhand> != air:
        - adjust <[entity]> item_in_offhand:<[entity].item_in_offhand.proc[dd_EnchantItem].context[<[enchantData]>]>

