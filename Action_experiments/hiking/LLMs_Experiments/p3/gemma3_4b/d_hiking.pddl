(define (domain hiking)

  (:requirements :strips)

  (:predicates
    (at ?h - hiker ?l - location)
    (rained ?l - location)
    (has-energy ?h - hiker)
    (path-clear ?from ?to - location)
  )

  (:action walk
    :parameters (?h - hiker ?from ?to - location)
    :precondition (and (at ?h ?from) (path-clear ?from ?to) (has-energy 
?h))
    :effect (and (at ?h ?to) (not (at ?h ?from)))
  )

  (:action rest
    :parameters (?h - hiker ?l - location)
    :precondition (at ?h ?l) (has-energy ?h)
    :effect (and (has-energy ?h))
  )

  (:action check-weather
    :parameters (?l - location)
    :precondition enone
    :effect (rained ?l)
  )
)