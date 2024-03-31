#Purpose is to select a random integer between two given values, with a triangular(ish) distribution curve
#Really simulates rolling two dice
dd_TrangularDistroRandomInt:
    debug: false
    type: procedure
    definitions: min|max
    script:
    #Sometimes 1|2 is passed in as a list properly to min/max, sometimes it goes straight into min.
    #Easier to do a quick check here...
    - if <[min].escaped.contains_all_text[&pipe]>:
        - define max <[min].after[|].round>
        - define min <[min].before[|].round>
    - else:
        - define max <[max].round>
        - define min <[min].round>

    - define r1 <util.random.int[<[min]>].to[<[max]>]>

    - if <[min]> > 0:
        - define min:--
    - define max:--
    - define r2 <util.random.int[<[min]>].to[<[max]>]>

    - determine <[r1].add[<[r2]>].div[2].round>