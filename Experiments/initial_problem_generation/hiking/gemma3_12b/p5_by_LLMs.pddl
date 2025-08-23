(define (problem hike-hard)
  (:domain hiking)
  (:objects
    h1 - hiker
    base rest-area danger-zone summit - location)
  (:init
    (at h1 base)
    (path-clear base rest-area)
    (path-clear rest-area danger-zone)
    (path-clear danger-zone summit)
    (not (rained danger-zone))  ; Danger Zone not raining initially
    (has-energy h1)         ; Hiker initially has energy
  )
  (:goal (at h1 summit)))