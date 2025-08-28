(define (problem hike-solvable)
  (:domain hiking)
  (:objects
    h1 - hiker
    base rest-area danger-zone summit - location)
  (:init
    (at h1 base)
    (path-clear base rest-area)
    (path-clear rest-area danger-zone)
    (path-clear danger-zone summit) ; Added this line
    (rained summit) ; Added this line
    (not (has-energy h1))
  )

