(define (problem logistics-problem)
  (:domain logistics)
  (:objects
    pkg1 - object
    truck1 - truck
    loc1 loc2 - location
    city1 - city
  )
  (:init
    ; Locations are within the same city
    (loc loc1 city1)
    (loc loc2 city1)

    ; Initial positions of the package and truck
    (at pkg1 loc1)   ; Package is at loc1 initially
    (at truck1 loc1)  ; Truck is also at loc1 initially

    ;; Additional initial conditions if needed for completeness:
    ;; We don't need to explicitly state locations as airports unless required.
    ;; For example, if we want to define these as airport type locations:
    ;; (loc loc1 airport)
    ;; (loc loc2 airport)

  )
  (:goal
    ; The goal is for the package to be at loc2
    (at pkg1 loc2)
  )
)