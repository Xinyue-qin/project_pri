(define (problem hike-easy)
  (:domain hiking)
  (:objects
    h1 - hiker
    base camp summit - location)
  (:init
    (at h1 base)
    (path-clear base camp)
    (path-clear camp summit)
    (has-energy h1))
  (:goal (at h1 summit)))