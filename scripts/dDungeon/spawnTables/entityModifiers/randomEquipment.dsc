dd_SpawnTables_RandomArmor:
    debug: false
    type: task
    definitions: entity|allowedMaterials
    data:
        materials:
            leather:
                armor_mod: 1
                weapon_mod: 0.5
            golden:
                armor_mod: 1
                weapon_mod: 0.5
            chainmail:
                armor_mod: 2
                weapon_mod: 0.75
            iron:
                armor_mod: 3
                weapon_mod: 0.75
            netherite:
                armor_mod: 4
                weapon_mod: 1.25
        armorSlots:
            head: helmet
            chest: chestplate
            boots: boots
            legs: leggings
    script:
    - define materialData <script.data_key[data.materials]>
    - define armorData <script.data_key[data.armorSlots]>

    - if !<[allowedMaterials].exists>:
        - define allowedMaterials <[materialData].keys>

    - define material <[allowedMaterials].random>
    - define materialData <[materialData.<[material]>]>

    #Equip armor slots
    - define equipSlotCount <proc[dd_trangulardistrorandomint].context[0|4]>
    - foreach <[armorData].keys.random[<[equipSlotCount]>]> as:equipSlot:
        - choose <[equipSlot]>:
            - case head:
                - equip <[entity]> head:<[material]>_<[armorData.<[equipSlot]>]>
            - case chest:
                - equip <[entity]> chest:<[material]>_<[armorData.<[equipSlot]>]>
            - case boots:
                - equip <[entity]> boots:<[material]>_<[armorData.<[equipSlot]>]>
            - case legs:
                - equip <[entity]> legs:<[material]>_<[armorData.<[equipSlot]>]>
        - flag <[entity]> dd_spawnPoints:+:<[materialData.armor_mod]>

    #Equip weapon
    - if <util.random_chance[80]>:
        - if <util.random_chance[75]>:
            - choose <[material]>:
                - case leather:
                    - equip <[entity]> hand:wooden_sword
                - case chainmail:
                    - equip <[entity]> hand:iron_sword
                - default:
                    - equip <[entity]> hand:<[material]>_sword
            - flag <[entity]> dd_spawnPoints:+:<[materialData.weapon_mod]>
        - else:
            - random:
                - equip <[entity]> hand:crossbow
                - equip <[entity]> hand:bow

    #Equip shield
    - if <util.random_chance[80]>:
        - equip <[entity]> offhand:shield
        - flag <[entity]> dd_spawnPoints:+:1

