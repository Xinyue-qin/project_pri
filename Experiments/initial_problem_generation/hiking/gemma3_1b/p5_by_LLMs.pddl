(define (problem hike-hard)
  (:domain hiking)
  (:objects
    h1 - hiker
    base rest-area danger-zone summit - location)
  (:init
    (at h1 base)
    (path-clear base rest-area)
    (path-clear danger-zone)
    (rained danger-zone)
    (not (has-energy h1)))
  (:goal (at h1 summit))
)

