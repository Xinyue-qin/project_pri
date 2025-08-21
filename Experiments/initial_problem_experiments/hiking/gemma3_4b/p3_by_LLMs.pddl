(define (problem hike-energy-revised)
  (:domain hiking)
  (:objects 
    h1 - hiker
    start mid end - location)
  (:init
    (at h1 start)
    (path-clear start mid)
    (not (rained mid)) ; Explicitly stating the weather is not rained at mid
  )