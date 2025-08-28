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
    (path-clear A C) ; Added path to help solve the problem
    (not (rained A))
    (not (rained B))
    (not (rained C))
    (not (rained D))
    (has-energy h1)
  )
)