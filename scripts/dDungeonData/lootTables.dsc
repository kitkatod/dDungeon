dd_LootTables:
    debug: false
    type: data
    lootTables:
        # Loot category name
        myTestCategory:

            # Determines the number of item entries to randomly select when this loot category is called
            # May use the format min|max to set a range to randomly select from instead (uses a triangular distribution)
            # (optional, default is 1)
            _selection_count: 3
            # Import all loot entries from the listed categories
            # Note that if an entry has the same key as another only one will be considered
            # (optional, default is to not import from any other categories)
            _import_from:
            - myLootCategory1
            - myLootCategory2
            # Will apply the allow_split_stack value to all items within the loot category
            # This is just a shortcut for setting allow_split_stack on every item
            # If allow_split_stack is specified on an item, that value overrides _allow_split_stack.
            # (optional, default is to ignore this setting and only use the item setting)
            _allow_split_stack: true

            # Flags specified at the LootTable level will be applied to all items created from the loot table
            # (optional, default is to not apply any flags)
            _flags:
                myFlagName: This Awesome Value

            # Define a default weight for the table; for instance, and often resused treasure table may have a
            # lower default weight.
            _weight: 10

            # Material name of the item see https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Material.html
            # May also be the name of an item or book script
            # May also be the name of a procedure script which returns an ItemTag. Will be executed without arguments/context
            # Anything after a '#' in this key is ignored (can allow defining the same item multiple times)
            cod:
                # set quantity to a single number to give a set value
                # use min|max to give a random amount in the specified range (uses a triangular distribution)
                # (Should either be set as a subkey here, or as the value of the item key. See below for an example with cod#butWithOnlyQuantitySet)
                quantity: 1|15
                # When quantity is more than 1 and the item allows stacking, this allows for spliting the quantity into multiple stacks
                # Each stack size is randomized between 10% of quantity and (either 55% of max stack size, or 55% of quantity, whichever is lower)
                # (optional, default is true)
                allow_split_stack: true
                # Used to make a weighted random selection
                # (optional, default is 100)
                weight: 100
                # Used to set the maximum number of times this can be selected if _selection_count is greater than 1
                # (optional, default is -1, which is treated as no limit)
                max_selection_count: -1
                # If the item has the ability to have a durability, randomize the durability, weighted towards the lower end of remaining durability
                # (optional, default is true)
                randomize_durability: true
                # Flags specified at the item level will only be applied to this item when it is created
                # (optional, default is to not apply any flags)
                _flags:
                    myFlagName: This Awesome Value (but only on this item)

                # Only used if the item is a Procedure Script.
                # If item is a Procedure Script and item_proc_args is supplied, the value of item_proc_args will be passed to the procedure as the single definition
                # Can be an Element, Map, List, etc.
                # (Optional, default is to pass nothing as context. This is not required to use a Procedure Script as an item.)
                item_proc_args: This is where I'd put my Proc Arg, If I had one.

                # Any procedure script names listed here will be executed.
                # First parameter will be the "current" ItemTag, second parameter will be whatever you place under the key (element, list, map, etc.)
                # (optional, default is to not execute any custom procedure modifiers)
                modifier_procs:
                    #First proc name to execute
                    dd_EnchantItem:
                        #These arguments are all specific to the script dd_EnchantItem. You can supply whatever you want to other procedures here.

                        # Whether to categorically disallow all enchantments marked as a curse
                        # (optional, default is true)
                        allow_curses: false
                        # Whether to allow enchantments to be set if they are above the normal max level.
                        # This does not affect enchantments which have a max level of 1 such as Mending; if selected they will always have a level of 1.
                        # (optional, default is false)
                        allow_enchants_over_max: true
                        # Enchantment Level to apply to the item
                        # Can be a single integer of in min|max format (uses a triangular distribution)
                        # (optional, default is between 1 and max for the enchantment)
                        enchantment_level: 1|4
                        # Max number of enchantments to apply to the item
                        # Can be a single integer or in min|max format (uses a triangular distribution)
                        # (optional, default is 1)
                        enchantment_count: 1
                        # List of enchantments to pick from
                        # (optional, default is all enchantments on the server)
                        allowed_enchantments:
                        - unbreaking
                        - mending
                        # List of enchantments to explicitly disallow selecting
                        # (Usually only allowed_ or disalowed_ would be specified. There's not really a reason to include both at once)
                        # (Note: This shouldn't be the case because it's silly and you shouldn't do it, but if an enchantment is on both allowed_ and disallowed_ lists the disallowed_ list will take priority for a given enchantment)
                        disallowed_enchantments:
                        - mending

            # If not setting any other detailed options on an item, you can also just set the value to be a quantity value, or quantity range
            cod#butWithOnlyQuantitySet: 1
            cod#butWithOnlyQuantityRangeSet: 2|5

            # Cod is defined a second time but with a comment at the end. The comment is ignored.
            cod#butWithSomeExtraText:
                weight: 1
                quantity: 3|9

            # This is the name of an item script
            dd_SchematicEditor:
                weight: 1
                quantity: 1

            # This is the name of a procedure script
            # (This specific procedure will roll another loot table and pick a single item from it. The "Other Loot Table" is specified with item_proc_args)
            dd_LootTables_SingleItemFromLootTable:
                item_proc_args: food

        food:
            _selection_count: 3
            wheat:
                weight: 300
                quantity: 10|24
                max_selection_count: 1
            cooked_cod: 2|5
            cooked_salmon: 2|5
            bread: 2|5
            cooked_chicken: 2|5
            potato: 4|10
            baked_potato: 2|5
            cooked_rabbit: 2|5
            suspicious_stew: 1|3
            water_bucket: 1|2
            cake:
                weight: 25
                quantity: 1
                max_selection_count: 1


        inn_bedroom:
            _selection_count: 3|7
            leather_boots:
                quantity: 1
                max_selection_count: 1
            leather_leggings:
                quantity: 1
                max_selection_count: 1
            leather_chestplate:
                quantity: 1
                max_selection_count: 1
            iron_sword:
                quantity: 1
                max_selection_count: 1
            suspicious_stew: 1|2
            mushroom_stew:
                weight: 300
                quantity: 1|2
                max_selection_count: 1
            apple:
                weight: 300
                quantity: 1|2
                max_selection_count: 1
            flint_and_steel: 1|2
            torch:
                weight: 1000
                quantity: 6|18
                max_selection_count: 1
            ladder: 6|12
            bucket: 1
            milk_bucket: 1
            water_bucket: 1
            brush: 1

        inn_bedroom_rare:
            _selection_count: 3|4
            iron_boots:
                quantity: 1
                max_selection_count: 1
            iron_leggings:
                quantity: 1
                max_selection_count: 1
            iron_chestplate:
                quantity: 1
                max_selection_count: 1
            iron_sword:
                quantity: 1
                max_selection_count: 1
            gold_ingot: 3|6
            rabbit_stew: 1|3
            emerald:
                weight: 50
                quantity: 1|2
            potion[potion_effects=[base_type=healing]]:
                weight: 50
                quantity: 1|2
            golden_apple:
                weight: 50
                quantity: 1|2

        blacksmith:
            _selection_count: 2|5
            iron_ingot:
                weight: 1000
                quantity: 5|15
                max_selection_count: 2
            iron_ore: 10|20
            gold_ingot:
                weight: 75
                quantity: 2|8
            gold_ore: 3|12
            coal: 2|8
            charcoal: 2|8
            diamond:
                weight: 10
                quantity: 1
            iron_sword:
                weight: 50
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|2
                        allowed_enchantments:
                        - unbreaking
                        - sharpness
                        - sweeping
            netherite_scrap:
                weight: 1
                quanitity: 1
                max_selection_count: 1

        library:
            _selection_count: 2
            dd_LootTables_SingleItemFromLootTable#books:
                item_proc_args: library_books
            book:
                weight: 250
                quantity: 1|3
            enchanted_book#normalBook:
                weight: 60
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|2
                        enchantment_count: 1|2
                        allowed_enchantments:
                        - blast_protection
                        - efficiency
                        - feather_falling
                        - fire_protection
                        - fortune
                        - knockback
                        - unbreaking
                        - sharpness
                        - sweeping
                        - vanishing_curse
                        - binding_curse

        library_lectern:
            _selection_count: 1
            dd_LootTables_SingleItemFromLootTable#books:
                item_proc_args: library_books
            writable_book: 1

        library_books:
            _weight: 20
            _import_from:
            - lb_hieroglyphs
            - lb_monolith
            - lb_creation
            - lb_end
            - lb_carwyn

        lb_hieroglyphs:
            book: 1
        lb_monolith:
            book: 1
        lb_creation:
            book: 1
        lb_end:
            book: 1
        lb_carwyn:
            book: 1

        crypt_pot:
            _selection_count: 1
            bone_meal:
                weight: 200
                quantity: 2|4
                allow_split_stack: false
            bone:
                weight: 100
                quantity: 4|32
                allow_split_stack: false
            bone_block:
                weight: 75
                quantity: 1|3
                allow_split_stack: false
            skeleton_skull:
                weight: 50
                quantity: 1
            iron_sword:
                weight: 50
                quantity: 1

        special_enchanted_book:
            _selection_count: 1
            enchanted_book#rareBook:
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1
                        enchantment_count: 1
                        allowed_enchantments:
                        - mending
                        - organizer
                        - vein_miner
                        - tree_feller

        furnace_fuel:
            _selection_count: 1
            _allow_split_stack: false
            coal: 4|8
            charcoal: 2|6

        furnace_blacksmith:
            _selection_count: 1
            _allow_split_stack: false
            raw_iron: 3|8
            raw_gold: 3|8
            raw_copper: 3|8

        furnace_kitchen:
            _selection_count: 1
            _allow_split_stack: false
            cod: 3|7
            salmon: 3|7
            beef: 3|7
            porkchop: 3|7
            mutton: 3|7
            rabbit: 3|7
            chicken: 3|7

        minor_treasure:
            _selection_count: 3|5
            diamond:
                weight: 200
                quantity: 1|2
                max_selection_count: 1
            quartz:
                weight: 500
                quantity: 10|20
            gold_ingot:
                weight: 400
                quantity: 5|10
            bell:
                weight: 100
                quantity: 1
            emerald:
                weight: 150
                quantity: 5|8
                max_selection_count: 1

        major_treasure:
            _selection_count: 3|6
            _import_from:
            - special_enchanted_book
            diamond:
                weight: 200
                quantity: 3|5
                max_selection_count: 1
            gold_ingot:
                weight: 400
                quantity: 5|10
            emerald:
                quantity: 5|8
                weight: 150
                max_selection_count: 1
            emerald_block:
                quantity: 1|2
                weight: 100
                max_selection_count: 1
            fire_charge:
                quantity: 3|8
                weight: 300
            quartz:
                quantity: 10|20
                weight: 500
            diamond_sword#sword:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
            diamond_pickaxe#pickaxe:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
                        - vanishing_curse
                        - binding_curse
            diamond_axe#axe:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
                        - vanishing_curse
                        - binding_curse
            diamond_helmet#helmet:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
                        - vanishing_curse
                        - binding_curse
            diamond_chestplate#chestplate:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
                        - vanishing_curse
                        - binding_curse
            diamond_leggings#leggings:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
                        - vanishing_curse
                        - binding_curse
            diamond_boots#boots:
                weight: 150
                max_selection_count: 1
                modifier_procs:
                    dd_EnchantItem:
                        enchantment_level: 1|4
                        enchantment_count: 1|2
                        disallowed_enchantments:
                        - mending
                        - vanishing_curse
                        - binding_curse

        trap_arrows:
            _selection_count: 9
            _allow_split_stack: false
            tipped_arrow[potion_effects=[base_type=harming]]:
                _flags:
                    dd_arrowNoPickup: true
                quantity: 5|10
            tnt:
                weight: 5
                max_selection_count: 1
                quantity: 1|3
            tipped_arrow[potion_effects=[base_type=slowness]]:
                _flags:
                    dd_arrowNoPickup: true
                quantity: 5|10
            tipped_arrow[potion_effects=[base_type=strong_poison]]:
                _flags:
                    dd_arrowNoPickup: true
                quantity: 5|10

        storeroom:
            _selection_count: 2|3
            dried_kelp: 4|8
            wheat:
                weight: 150
                quantity: 10|24
            bread: 4|6
            melon_seeds:
                weight: 150
                quantity: 10|24
            pumpkin_seeds:
                weight: 150
                quantity: 10|24
            iron_hoe: 1
            arrow: 10|24
            gunpowder:
                weight: 50
                quantity: 4|8
            fishing_rod: 1
            cocoa_beans: 3|6

        adventure_chest:
            _selection_count: 2|4
            _import_from:
            - inn_bedroom
            skeleton_skull:
                weight: 50
                quantity: 1
            bone:
                weight: 200
                quantity: 2|4
            rotten_flesh:
                weight: 200
                quantity: 2|4
            lantern:
                weight: 100
                quantity: 1|3
            candle:
                weight: 100
                quantity: 4|8

        generic_pot:
            arrow: 10|24
            wheat:
                weight: 150
                quantity: 10|24
            torch:
                weight: 200
                quantity: 6|18
                max_selection_count: 1
            emerald:
                quantity: 1|3
                weight: 25

        prison:
            bone: 1|3
            chain: 2|6
            rotten_flesh: 3|8
            bowl: 1|2
