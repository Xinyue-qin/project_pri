(define (problem delivery-competition-alternative)
  (:domain delivery)
  (:objects
    courier1 courier2 - agent
    urgentPkg normalPkg - package
    warehouse station client - location
  )
  (:init
    (at courier1 warehouse)
    (at courier2 station)
    (connected station client)
    (requested urgentPkg client)
    (requested normalPkg client)
    (available courier1)(available courier2)
    (in urgentPkg warehouse)
    (in normalPkg warehouse)
  )
  (:goal (and (delivered urgentPkg)(delivered normalPkg))))