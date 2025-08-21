(define (problem logistics-3)
  (:domain logistics)
  (:objects
    pkg1 pkg2 pkg3 - object
    truck1 truck2 - truck
    plane1 - airplane
    loc1 loc2 - location
    airport1 airport2 - airport
    city1 city2 - city
  )
  (:init
    (loc loc1 city1)
    (loc airport1 city1)
    (loc loc2 city2)
    (loc airport2 city2)
    (at pkg1 loc1)
    (at pkg2 airport1)
    (at pkg3 loc2)
  )
  (:goal (and (at pkg1 loc2) (at pkg2 airport2) (at pkg3 loc1)))
)