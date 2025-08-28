(define (problem hike-weather)
  (:domain hiking)
  (:objects
    h1 - hiker
    lodge trail peak - location)
  (:init
    (at h1 lodge)
    (path-clear lodge trail)
    (path-clear trail peak)
    (has-energy h1)
    ; Implicitly assume no rain initially at any locations (important for allowing walk)
  )
  (:goal (at h1 peak)))


