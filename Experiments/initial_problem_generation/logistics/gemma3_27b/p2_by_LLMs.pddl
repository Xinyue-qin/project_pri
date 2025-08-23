(define (problem logistics-2)
  (:domain logistics)
  (:objects
    pkg1 pkg2 - object
    truck1 - truck
    plane1 - airplane
    loc1 - location
    airport1 airport2 - airport
    city1 city2 - city
  )
  (:init
    (at truck1 airport1)
    (at plane1 airport1)
    (at pkg1 airport1)
    (at pkg2 airport1)

    ;; Add the location relationships
    (loc airport1 city1)
    (loc airport2 city2)
    (loc loc1 city1)

    ;;Important: Link the cities
    (loc city1 city2)
  )
  (:goal (and (at pkg1 airport2) (at pkg2 airport2))))