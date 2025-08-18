(define (domain hiking)
  (:requirements :strips :typing)
  (:types
    hiker location
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
    )
    :effect (and
      (not (at ?h ?from))
      (at ?h ?to)
    )
  )

  (:action rest
    :parameters (?h - hiker ?l - location)
    :precondition (and
      (at ?h ?l)
      (has-energy ?h)
    )
    :effect (and
      (has-energy ?h)
    )
  )

  (:action check-weather
    :parameters (?l - location)
    :precondition ()
    :effect (and
      ;; This effect is a placeholder; you need a way to determine rain 
status.
      ;; In a real domain, this would likely involve a sensor or an 
external source.
      ;;  (rained ?l) 
      ;;  ;For the demonstration we assume that rain status is given.
    )
  )
)