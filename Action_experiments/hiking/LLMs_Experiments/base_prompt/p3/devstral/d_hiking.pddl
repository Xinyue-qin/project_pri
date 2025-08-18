(define (domain hiking)
  (:requirements :strips :typing)

  ;; Define types for hiker and location
  (:types hiker location)

  ;; Define predicates
  (:predicates
    (at ?h - hiker ?l - location)
    (rained ?l - location)
    (has-energy ?h - hiker)
    (path-clear ?from - location ?to - location)
  )

  ;; Action: walk
  (:action walk
    :parameters (?h - hiker ?from - location ?to - location)
    :precondition (and (at ?h ?from) (has-energy ?h) (path-clear ?from ?to))
    :effect (and (not (at ?h ?from)) (at ?h ?to))
  )

  ;; Action: rest
  (:action rest
    :parameters (?h - hiker ?l - location)
    :precondition (and (at ?h ?l) (has-energy ?h))
    :effect (and (not (has-energy ?h)))
  )

  ;; Action: check-weather
  (:action check-weather
    :parameters (?l - location)
    :precondition (true)
    :effect (rained ?l)
  )
)
