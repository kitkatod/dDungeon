dd_LoadAreaChunks:
    debug: false
    type: task
    definitions: tChunk|chunkRange|duration
    script:
    - define x <[chunkRange].mul[-1]>
    - define y <[chunkRange].mul[-1]>
    - while <[x]> <= <[chunkRange]> && <[y]> <= <[chunkRange]>:
        - chunkload <[tChunk].add[<[x]>,<[y]>]> duration:<[duration]>
        - define x:++
        - if <[x]> > <[chunkRange]>:
            - define x <[chunkRange].mul[-1]>
            - define y:++