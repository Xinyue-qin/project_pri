(define (problem logistics-problem-revised)
  (:domain logistics)
  (:objects
    pkg1 - object
    truck1 - truck
    loc1 loc2 - location
    city1 - city
  )
  (:init
    (loc loc1 city1)
    (loc loc2 city1)
    (at pkg1 loc1)
  )
  (:goal (at pkg1 loc2))