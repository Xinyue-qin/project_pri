(define (domain hiking)
  (:requirements :strips :typing)
  (:types hiker location)

  (:predicates
    (at ?h - hiker ?l - location)
    (rained ?l - location)
    (has-energy ?h - hiker)
    (path-clear ?from ?to - location)
  )

  (:action walk
    :parameters (?h - hiker ?from - location ?to - location)
    :precondition (and
      (at ?h ?from)
      (path-clear ?from ?to)
      (not (rained ?to))
      (has-energy ?h)
    )
    :effect (and
      (not (at ?h ?from))
      (at ?h ?to)
      (not (has-energy ?h))
    )
  )

  (:action rest
    :parameters (?h - hiker ?l - location)
    :precondition (at ?h ?l)
    :effect (has-energy ?h)
  )

  (:action check-weather
    :parameters (?l - location)
    :precondition (rained ?l)
    :effect (not (rained ?l))
  )
)