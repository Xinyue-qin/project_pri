(define (problem hike-preference)
  (:domain hiking)
  (:objects
    h1 - hiker
    A B C D - location)
  (:init
    (at h1 A)
    (path-clear A B)
    (path-clear B C)
    (path-clear C D)
    (has-energy h1)  ;Crucially, the hiker must have energy to act
  )
  (:goal (at h1 D)))