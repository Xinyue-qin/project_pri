(define (problem hike-preference)
  (:domain hiking)
  (:objects
    h1 - hiker
    A B C D - location)
  (:init
    ; H1 starts at A location
    (at h1 A)

    ; Paths are clear
    (path-clear A B)
    (path-clear B C)
    (path-clear C D)

    ; No rain initially assumed for simplicity, can be verified later if needed
    (not (rained A))
    (not (rained B))
    (not (rained C))
    (not (rained D))

    ; H1 has energy to perform actions
    (has-energy h1)
  )
  (:goal (at h1 D))
)