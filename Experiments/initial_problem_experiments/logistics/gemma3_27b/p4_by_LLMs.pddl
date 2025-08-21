(:init
    ; City 1 locations
    (loc loc1 city1)
    (loc airport1 city1)
    
    ; City 2 locations
    (loc loc2 city2)
    (loc airport3 city2) ; New Airport for city 2

    ; City 3 locations (only needs airport since we're delivering to loc3)
    (loc loc3 city3)
    (loc airport2 city3)  ; Sharing airport2 between city3
    
    ; Vehicles
    (at truck1 loc1)
    (at truck2 airport2)
    (at plane1 airport1)
    
    ; Packages
    (at pkg1 loc1)
    (at pkg2 airport1)

    ;Crucial additions to make this solvable:
    ; Load pkg1 onto truck1
    (in pkg1 truck1)
    ; Load pkg2 onto plane1
    (in pkg2 plane1)

)