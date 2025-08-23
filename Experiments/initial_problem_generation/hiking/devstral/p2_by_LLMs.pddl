(define (problem hike-weather)
  (:domain hiking)
  (:objects
    h1 - hiker
    lodge trail peak - location)
  (:init
    ; H1 starts at the lodge
    (at h1 lodge)

    ; Paths are clear
    (path-clear lodge trail)
    (path-clear trail peak)

    ; No rain at starting points, can be verified later if needed
    (not (rained lodge))
    (not (rained trail))

    ; H1 has energy
    (has-energy h1)
  )
  (:goal (at h1 peak))
)