(define (problem delivery-dynamic)
  (:domain delivery)
  (:objects
    drone medicalPkg hospital depot disasterArea - object
  )
  (:init
    (connected depot hospital)
    (connected hospital disasterArea)
    (requested medicalPkg disasterArea)
    (not (connected depot disasterArea))
    (available drone)
  )
  (:goal (delivered medicalPkg))
)