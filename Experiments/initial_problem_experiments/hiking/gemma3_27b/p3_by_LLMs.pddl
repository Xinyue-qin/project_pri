(define (problem hike-energy)
  (:domain hiking)
  (:objects
    h1 - hiker
    start mid end - location)
  (:init
    (at h1 start)
    (path-clear start mid)
    (path-clear mid end)
    (has-energy h1)
    (not (rained start))
    (not (rained mid))
    (not (rained end))
  )
  (:goal (at h1 end)))