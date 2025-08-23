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
    (at robot1 locA)          ; Robot starts at location A
    (in pkg1 locA)            ; Package is at location A
  )
  (:goal (delivered pkg1))
)