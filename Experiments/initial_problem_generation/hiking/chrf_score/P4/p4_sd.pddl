(define (problem hike-preference)
  (:domain hiking)
  (:objects
    h1 - hiker
    A B C D - location)
  (:init
    (at h1 A)
    (path-clear A B) (path-clear B D)  ; Path 1
    (path-clear A C) (path-clear C D)  ; Path 2
    (prefer (not (rained C))))         ; 偏好路径2
  (:goal (at h1 D)))