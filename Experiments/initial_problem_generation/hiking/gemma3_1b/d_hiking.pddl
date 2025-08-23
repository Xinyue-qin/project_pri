(define (domain hiking)
  (:requirements :strips :typing)  ; 
  (:types 
    hiker 
    location
  )
  
  (:predicates 
    (at ?h - hiker ?l - location)
    (rained ?l - location)
    (has-energy ?h - hiker)
    (path-clear ?from ?to - location)
  )

  (:action walk
    :parameters (?h - hiker ?from ?to - location)
    :precondition (and 
      (at ?h ?from)
      (path-clear ?from ?to)
      (not (rained ?to)))
    :effect (and 
      (not (at ?h ?from))
      (at ?h ?to))
  )

  (:action rest
    :parameters (?h - hiker ?l - location)
    :effect (has-energy ?h)
  )

  (:action check-weather
    :parameters (?l - location)
    :effect (not (rained ?l))  ; 
  )
)