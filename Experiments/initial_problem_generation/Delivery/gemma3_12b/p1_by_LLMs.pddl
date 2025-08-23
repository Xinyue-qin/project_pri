(define (problem delivery-basic)
(:domain delivery)
(:objects
  robot1 - agent
  pkg1 - package
  locA locB - location
)
(:init
  (connected locA locB)
  (available robot1)
  (at robot1 locA)
  (in pkg1 locA)
  (requested pkg1 locB)
)
(:goal (delivered pkg1)))