(define (problem hike-energy)
  (:domain hiking)
  (:objects 
    h1 - hiker
    start mid end - location)
  (:init
    (at h1 start)
    (path-clear start mid))
  (:goal (at h1 end))
)