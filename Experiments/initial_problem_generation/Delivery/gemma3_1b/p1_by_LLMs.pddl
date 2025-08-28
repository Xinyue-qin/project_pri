(define (problem delivery-basic)
  (:domain delivery)
  (:objects
    robot1 - agent
    pkg1 - package
    locA locB - location
  )
  (:init
    (connected locA locB)
    (requested pkg1 locB)
    (available robot1)
  )
  (:goal (delivered pkg1))

