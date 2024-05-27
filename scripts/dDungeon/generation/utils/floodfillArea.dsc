dd_FloodfillArea:
    debug: false
    type: task
    definitions: area|backfillLocation|matcher|material|checkTime
    script:
    #Dummy check, stop if location isn't in the area
    - if !<[area].contains[<[backfillLocation]>]>:
        - stop

    #Default parameter fill if material wasn't passed
    - if !<[matcher].exists>:
        - define matcher <[backfillLocation].material.name>

    #Check that location matches matcher
    - if <[matcher]> !matches <[matcher]>:
        - stop

    #List of what still needs to be checked
    - define checkQueue <list[<[backfillLocation]>]>

    #This feels hacky, but maintaining a list of checked locations quickly crashes the server...
    #Map is in the form of checkedMap.X.Y.Z
    #If a coordinate-key exists, it's been checked already and doesn't need to be checked again
    - define checkedMap <map[]>

    #Keep checking locations on the queue until we've run the queue empty
    - while !<[checkQueue].is_empty>:
        #Pop next location off queue
        - define checkLoc <[checkQueue].first>
        - define checkQueue:<-:<[checkLoc]>
        #Mark the location as checked
        - define checkedMap.<[checkLoc].x>.<[checkLoc].y>.<[checkLoc].z> true

        #If we're spending too much time, wait a tick to slow down a bit
        - if <util.time_now.duration_since[<[checkTime]>].in_milliseconds> >= 40:
            - wait 1t
            - define checkTime <util.time_now>

        #If location is outside area just move on
        - if !<[area].contains[<[checkLoc]>]>:
            - while next

        #If block matches, replace the block
        - if <[checkLoc]> matches <[matcher]>:
            - ~modifyblock <[checkLoc]> <[material]>

            #For each of the 6 locations around, check if it has already been checked.
            #If it hasn't, queue it to be checked
            - define nextCheck <[checkLoc].add[1,0,0]>
            - if !<[checkedMap.<[nextCheck].x>.<[nextCheck].y>.<[nextCheck].z>].exists>:
                - define checkQueue:->:<[nextCheck]>

            - define nextCheck <[checkLoc].add[-1,0,0]>
            - if !<[checkedMap.<[nextCheck].x>.<[nextCheck].y>.<[nextCheck].z>].exists>:
                - define checkQueue:->:<[nextCheck]>

            - define nextCheck <[checkLoc].add[0,1,0]>
            - if !<[checkedMap.<[nextCheck].x>.<[nextCheck].y>.<[nextCheck].z>].exists>:
                - define checkQueue:->:<[nextCheck]>

            - define nextCheck <[checkLoc].add[0,-1,0]>
            - if !<[checkedMap.<[nextCheck].x>.<[nextCheck].y>.<[nextCheck].z>].exists>:
                - define checkQueue:->:<[nextCheck]>

            - define nextCheck <[checkLoc].add[0,0,1]>
            - if !<[checkedMap.<[nextCheck].x>.<[nextCheck].y>.<[nextCheck].z>].exists>:
                - define checkQueue:->:<[nextCheck]>

            - define nextCheck <[checkLoc].add[0,0,-1]>
            - if !<[checkedMap.<[nextCheck].x>.<[nextCheck].y>.<[nextCheck].z>].exists>:
                - define checkQueue:->:<[nextCheck]>