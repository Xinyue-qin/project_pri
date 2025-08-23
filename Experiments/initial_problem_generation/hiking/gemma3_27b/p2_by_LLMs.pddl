(define (problem hike-weather)
  (:domain hiking)
  (:objects
    h1 - hiker
    lodge trail peak - location)
  (:init
      (at h1 lodge)
      (path-clear lodge trail)
      (path-clear trail peak)
      (has-energy h1)
      (not (rained peak))  ; Crucially, we state it's not raining at the peak initially
  )
  (:goal (at h1 peak)))