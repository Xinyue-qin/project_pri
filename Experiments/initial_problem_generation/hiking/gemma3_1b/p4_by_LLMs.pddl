(define (problem hike-preference)
  (:domain hiking)
  (:objects
    h1 - hiker
    A B C D - location)
  (:init
    (at h1 A)
    (path-clear A B)
    (prefer (not (rained C))))
  (:goal (at h1 D))
)