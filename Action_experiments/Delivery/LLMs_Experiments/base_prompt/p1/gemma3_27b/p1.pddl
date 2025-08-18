(define (problem delivery-basic)
(:domain delivery)
(:objects
  robot1 - agent
  pkg1 - package
  locA locB - location
)
(:init
  (at robot1 locA)
  (in pkg1 locA)
  (connected locA locB)
  (requested pkg1 locB)
  (available robot1)
)
(:goal (delivered pkg1)))