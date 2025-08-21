(define (problem hike-easy-alt)
  (:domain hiking)
  (:objects
    h1 - hiker
    base camp summit - location)
  (:init
    (path-clear camp summit)
    (at h1 camp)
    (has-energy h1)
    (not (rained summit))
  )
  (:goal (at h1 summit))

