(define (problem delivery-dynamic)
(:domain delivery)
(:objects
  drone - agent
  medicalPkg - package
  hospital depot disasterArea - location
)
(:init
  (connected depot hospital)
  (connected hospital disasterArea)
  (requested medicalPkg disasterArea)
  (not (connected depot disasterArea))
  (available drone)
  (at drone depot)
  (in medicalPkg depot)
)
(:goal (delivered medicalPkg)))