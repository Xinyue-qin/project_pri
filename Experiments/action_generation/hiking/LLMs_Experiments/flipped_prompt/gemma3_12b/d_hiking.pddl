(define (domain hiking)
  (:requirements :strips :typing)
  (:types
    location hiker
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
      (not (rained ?to))
      (has-energy ?h)
    )
    :effect (and
      (not (at ?h ?from))
      (at ?h ?to)
      (not (has-energy ?h)) ; Walking consumes energy
    )
  )

  (:action rest
    :parameters (?h - hiker ?l - location)
    :precondition (and
      (at ?h ?l)
    )
    :effect (and
      (has-energy ?h)
    )
  )

  (:action check-weather
    :parameters (?l - location)
    :precondition (and
    )
    :effect (and
      (not (rained ?l))
    )
  )
)