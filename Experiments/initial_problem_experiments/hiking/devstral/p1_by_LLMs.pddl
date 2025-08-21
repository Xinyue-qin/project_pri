(define (problem hike-easy)
  (:domain hiking)
  (:objects
    h1 - hiker
    base camp summit - location)
  (:init
    ; H1 starts at the base camp
    (at h1 base)
    (path-clear base camp)
    (path-clear camp summit)
    (has-energy h1)
    ; No rain initially assumed for simplicity, but this could also be handled by 
including check-weather actions in the plan
  )
  (:goal (at h1 summit))
)