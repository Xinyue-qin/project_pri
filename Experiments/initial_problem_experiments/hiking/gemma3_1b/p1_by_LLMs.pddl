(define (problem hike-easy)
  (:domain hiking)
  (:objects
    h1 - hiker
    base camp summit - location)
  (:init
    (path-clear camp summit)
    (has-energy h1)
  )
  (:goal (at h1 summit)))

