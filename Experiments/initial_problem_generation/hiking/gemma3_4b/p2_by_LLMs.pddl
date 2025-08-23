(define (problem hike-weather-revised)
  (:domain hiking)
  (:objects
    h1 - hiker
    lodge trail peak - location)
  (:init
    (at h1 lodge)
    (path-clear lodge trail)
    (path-clear trail peak)
    (has-energy h1)
    (not (rained lodge))
    (not (rained trail))
  )
  (:goal (at h1 peak))
)