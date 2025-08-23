(define (problem delivery-competition)
  (:domain delivery)
  (:objects
    courier1 courier2 - agent
    urgentPkg normalPkg - package
    warehouse station client - location
  )
  (:init
    (at courier1 warehouse)
    (at courier2 station)
    (in urgentPkg warehouse) ; Urgent package is at the warehouse
    (in normalPkg station)   ; Normal package is at the station
    (connected warehouse station) ; Connect warehouse to station
    (connected station client)    ; Connect station to client location
    (requested urgentPkg client)
    (requested normalPkg client)
    (available courier1)
    (available courier2)
  )
  (:goal (and (delivered urgentPkg)(delivered normalPkg)))
)

