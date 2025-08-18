(define (problem delivery-dynamic)
(:domain delivery)
(:objects
  drone - agent
  medicalPkg - package
  hospital depot disasterArea - location
)
(:init
  (at drone depot)
  (in medicalPkg depot)
  (connected depot hospital)
  (connected hospital disasterArea)
  (requested medicalPkg disasterArea)
  (not (connected depot disasterArea)) ; 必须经医院中转
  (available drone)
)
(:goal (delivered medicalPkg)))