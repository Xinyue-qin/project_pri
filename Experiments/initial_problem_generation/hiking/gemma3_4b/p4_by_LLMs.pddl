(define (problem hike-preference)
  (:domain hiking)
  (:objects
    h1 - hiker
    A B C D - location)
  (:init
    (at h1 A)
    (path-clear A B)
    (path-clear A C)
    (path-clear C D)
    (prefer D))
  (:goal (at h1 D))


