dd_RotationFromVector:
    debug: false
    type: procedure
    definitions: vector
    script:
    - if <[vector].X> = 1:
        - determine 0
    - else if <[vector].X> = -1:
        - determine 180
    - else if <[vector].Z> = 1:
        - determine 90
    - else if <[vector].Z> = -1:
        - determine 270
    - else:
        - determine 0