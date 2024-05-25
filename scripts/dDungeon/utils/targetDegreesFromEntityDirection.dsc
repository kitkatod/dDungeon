dd_Util_TargetDegreesFromEntityDirection:
    debug: false
    type: procedure
    definitions: entity[Entity to get 'viewing' direction from (usually the player)]|target[Entity or Location to calculate angle distance for]
    script:
    #Target input can either be a location or entity
    - if <[target].object_type> == location:
        - define targetLoc <[target]>
    - else:
        - define targetLoc <[target].location>

    #Get relevant variables
    - define entityEyeVector <[entity].eye_location.direction.vector>
    - define targetRelativeVector <[entity].location.sub[<[targetLoc]>]>
    - define targetDistance <[entity].location.distance[<[targetLoc]>]>

    #Formula for Radians between two vectors is
    ## =ACOS( (x1*x2 + y1*y2 + z1+z2) / (vect1Length * vect2Length) )

    - define relativeDegrees <[targetRelativeVector].proc[dd_Util_VectorsDotProduct].context[<[entityEyeVector]>].div[<[targetDistance]>].acos.to_degrees>
    - determine <element[180].sub[<[relativeDegrees]>]>

dd_Util_VectorsDotProduct:
    debug: false
    type: procedure
    definitions: loc1|loc2
    script:
    - define d <[loc1].x.mul[<[loc2].x>]>
    - define d:+:<[loc1].y.mul[<[loc2].y>]>
    - define d:+:<[loc1].z.mul[<[loc2].z>]>
    - determine <[d]>
