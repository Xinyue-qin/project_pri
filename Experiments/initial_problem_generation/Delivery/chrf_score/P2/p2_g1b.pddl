(define (problem delivery-multi-priority)
  (:domain delivery)
  (:objects
    robot2 - agent
    pkgA pkgB - package
    loc1 loc2 loc3 - location
  )
  (:init
    (in pkgA loc1)(in pkgB loc2)
    (connected loc1 loc2)(connected loc2 loc3)
    (requested pkgA loc3)(requested pkgB loc1)
    (available robot2)
  )
  (:goal (and (delivered pkgA)(delivered pkgB)))
)