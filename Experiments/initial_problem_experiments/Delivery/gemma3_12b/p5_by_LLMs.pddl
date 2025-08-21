(define (problem delivery-dynamic)
(:domain delivery)
(:objects
  drone - agent
  medicalPkg - package
  hospital depot disasterArea - location
)
(:init
  (at drone depot)  ; Drone starts at the depot. Crucial!
  (in medicalPkg depot) ; Package starts at the depot.  Crucial!
  (connected depot hospital)
  (connected hospital disasterArea)
  (requested medicalPkg disasterArea)
  (not (connected depot disasterArea)) ; 必须经医院中转
  (available drone)
)
(:goal (and 
        (not (in medicalPkg depot)) ;The package is no longer at the depot
       )
)