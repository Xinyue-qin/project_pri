(define (problem logistics-5)
  (:domain logistics)
  (:objects
    pkg1 pkg2 pkg3 pkg4 - object
    truck1 truck2 truck3 - truck
    plane1 plane2 - airplane
    loc1 loc2 loc3 - location
    airport1 airport2 airport3 - airport
    city1 city2 city3 - city
  )
  (:init
    (loc loc1 city1)
    (loc airport1 city1)
    (loc loc2 city2)
    (loc airport2 city2)
    (loc loc3 city3)
    (loc airport3 city3)
    (at truck1 loc1)
    (at truck2 loc2)
    (at truck3 loc3)
    (at plane1 airport1)
    (at plane2 airport2)
    (at pkg1 loc1)
    (at pkg2 airport1)
    (at pkg3 loc2)
    (at pkg4 airport3)
  )
  (:goal (and (at pkg1 loc3) (at pkg2 airport3) 
               (at pkg3 loc1) (at pkg4 airport2)))
)