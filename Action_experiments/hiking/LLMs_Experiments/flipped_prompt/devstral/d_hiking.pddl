(define (domain HIKING)
  (:requirements :strips :typing)

  ;; Define types
  (:types hiker location)

  ;; Define predicates
  (:predicates
    (at ?h - hiker ?l - location)
    (rained ?l - location)
    (has-energy ?h - hiker)
    (path-clear ?from - location ?to - location)
  )

  ;; Define the "walk" action
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
    )
  )

  ;; Define the "rest" action
  (:action rest
    :parameters (?h - hiker ?l - location)
    :precondition (and
      (at ?h ?l)
      (has-energy ?h)
    )
    :effect (and
      (not (has-energy ?h))
    )
  )

  ;; Define the "check-weather" action
  (:action check-weather
    :parameters (?l - location)
    :precondition (rained ?l)
    :effect (not (rained ?l))
  )
)