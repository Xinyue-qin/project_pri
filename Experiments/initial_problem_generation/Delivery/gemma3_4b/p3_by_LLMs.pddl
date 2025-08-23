(define (problem delivery-alternative)
  (:domain delivery)
  (:objects
    robotA robotB - agent
    pkgX - package
    locX locY locZ - location
  )
  (:init
    (at robotA locX)
    (at robotB locZ)
    (in pkgX locX)
    (connected locX locY)
    (connected locY locZ)
    (requested pkgX locZ)
    (available robotA)
    (available robotB)
  )
  (:goal (delivered pkgX))