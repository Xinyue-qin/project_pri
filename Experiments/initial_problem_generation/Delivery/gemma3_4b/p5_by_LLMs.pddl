(define (problem delivery-dynamic)
  (:domain delivery)
  (:objects
    drone - agent
    medicalPkg - package
    hospital depot disasterArea - location
  )
  (:init
    (connected depot disasterArea)  ; Direct connection from depot to 
disasterArea
    (requested medicalPkg disasterArea)
    (available drone)
  )
  (:goal (delivered medicalPkg))