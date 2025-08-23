(define (problem hike-energy)
  (:domain hiking)
  (:objects 
    h1 - hiker
    start mid end - location)
  (:init
    (at h1 start)
    (path-clear start mid)
    (path-clear mid end) ; Allow walking from mid to end.
    (not (rained start)) ; Start location is dry
    (not (rained mid)) ; Mid location is dry
    (not (rained end))) ; End location is dry
    (has-energy h1) ;  Ensures the hiker starts with energy, needed for walking.
  )
  (:goal (at h1 end)))