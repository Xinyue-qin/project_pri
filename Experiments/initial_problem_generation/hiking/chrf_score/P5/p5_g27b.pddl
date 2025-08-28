(define (problem hike-hard-solvable)
  (:domain hiking)
  (:objects
    h1 - hiker
    base rest-area danger-zone summit - location)
  (:init
    (at h1 base)
    (path-clear base rest-area)
    (path-clear rest-area danger-zone)
    (path-clear danger-zone summit)
    (has-energy h1)
    (not (rained danger-zone))
    (not (rained summit))
    (not (rained base))
    (not (rained rest-area))
  )
  (:goal (at h1 summit)))