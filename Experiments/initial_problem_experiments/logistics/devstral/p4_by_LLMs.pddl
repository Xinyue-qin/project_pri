(define (problem logistics-4)
  (:domain logistics)
  (:objects
    pkg1 pkg2 - object
    truck1 truck2 - truck
    plane1 - airplane
    loc1 loc2 loc3 - location
    airport1 airport2 - airport
    city1 city2 city3 - city
  )
  (:init
  ; City 1 locations
  (loc loc1 city1)
  (loc airport1 city1)

  ; City 2 locations
  (loc loc2 city2)

  ; City 3 locations (only needs airport since we're delivering to loc3)
  (loc loc3 city3)
  (loc airport2 city3)  ; Sharing airport2 between city2 and city3

  ; Vehicles
  (at truck1 loc1)
  (at plane1 airport1)

  ; Packages
  (at pkg1 loc1)
  (at pkg2 airport1)

  ; Add the initial locations for all vehicles and objects to ensure they can move according to the problem constraints
  (in pkg1 truck1)  ; Package 1 is already loaded on truck 1 at location loc1
  (in pkg2 plane1)  ; Package 2 is already loaded on plane 1 at airport1

  ; Make sure that vehicle positions are correct and share the same city when needed
)
  (:goal (and (at pkg1 loc3) (at pkg2 loc2)))
)