(define (problem delivery-dynamic)
(:domain delivery)
(:objects
  drone - agent
  medicalPkg - package
  hospital depot disasterArea - location
)
(:init
  (at drone depot) ; Drone starts at the depot
  (in medicalPkg depot) ; Package starts at the depot
  (connected depot hospital)
  (connected hospital disasterArea)
  (requested medicalPkg disasterArea)
  (not (connected depot disasterArea)) ; Must go through hospital
  (available drone)
)
(:goal (delivered medicalPkg))
)