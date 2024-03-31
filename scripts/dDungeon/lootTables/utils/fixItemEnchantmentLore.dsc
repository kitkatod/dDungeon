dd_LootTables_FixItemEnchantmentLore:
    debug: false
    type: procedure
    definitions: item
    script:
    - define enchantments <[item].enchantment_map>
    - define newLore <list>
    - foreach <[item].lore.if_null[<list>]> as:loreLine:
        #Only keep the lore line if it doesn't start with <gray>.
        #We'll try to make only enchantment lore be gray, to match with real enchantment "lore"
        - if <[loreline].starts_with[<gray>].not>:
            - define newLore:->:<[loreLine]>

    - foreach <[enchantments]> key:encKey as:lvl:
        - define enc <enchantment[<[encKey]>]>
        - if <[enc].key.starts_with[minecraft:]>:
            - foreach next
        - define "newLore:->:<gray><[enc].full_name[0].before[ 0]> <[lvl].to_roman_numerals>"

    - adjust def:item lore:<[newLore]>
    - determine <[item]>