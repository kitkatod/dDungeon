dd_LootTables_ItemFromInput:
    debug: false
    type: procedure
    definitions: input|args
    script:
    #Check if it's just an item/book. Should be able to be treated as an item and return.
    - if !<script[<[input]>].exists> || <script[<[input]>].data_key[type]> matches item|book:
        - determine <[input].as[item]>
    #Check if it's a procedure script. Execute procedure and return item, if it's actually an item...
    - else if <script[<[input]>].data_key[type]> == procedure:
        - define item <proc[<[input]>].context[<[args].if_null[null]>].if_null[null]>
        - if <[item].object_type> != item:
            - define item null
        - determine <[item]>

    #Final return if we haven't returned yet
    - determine null