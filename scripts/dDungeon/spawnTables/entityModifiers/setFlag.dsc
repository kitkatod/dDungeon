my_task:
    type: task
    definitions: cchance|entity|flag|value
    script:
    - if <[value].exists>:
        - flag <[entity]> <[flag]>:<[value]>
    - else:
        - flag <[entity]> <[flag]>