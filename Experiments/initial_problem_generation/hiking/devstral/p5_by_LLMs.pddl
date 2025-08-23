(define (problem hike-hard)
  (:domain hiking)
  (:objects
    h1 - hiker
    base rest-area danger-zone summit - location)
  (:init
    ; H1 starts at base location
    (at h1 base)

    ; Paths are clear
    (path-clear base rest-area)
    (path-clear rest-area danger-zone)
    (path-clear danger-zone summit)

    ; No rain initially assumed for simplicity, can be verified later if needed
    (not (rained base))
    (not (rained rest-area))

    ; H1 does not have energy initially
    (not (has-energy h1))
  )
  (:goal (at h1 summit))
)