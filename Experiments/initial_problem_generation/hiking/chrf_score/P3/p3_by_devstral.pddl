(define (problem hike-energy)
  (:domain hiking)
  (:objects
    h1 - hiker
    start mid end - location)
  (:init
    ; H1 starts at start location
    (at h1 start)

    ; Paths are clear
    (path-clear start mid)
    (path-clear mid end)

    ; No rain initially assumed for simplicity, can be verified later if needed
    (not (rained start))
    (not (rained mid))
    (not (rained end))

    ; H1 has energy to perform actions
    (has-energy h1)
  )
  (:goal (at h1 end))
)