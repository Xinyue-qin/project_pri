(define (problem hike-easy)
  (:domain hiking)
  (:objects
    h1 - hiker
    base camp summit - location)
  (:init
    (at h1 base camp)  ; Hiker starts at the base camp
    (path-clear base camp summit) ; Clear path from base camp to summit
    (has-energy h1)
  )
  (:goal (at h1 summit))
)
