(define (domain delivery)
  (:requirements :strips :typing)
  (:types
    agent package location
  )

  (:predicates
    (at ?a - agent ?l - location)
    (has ?a - agent ?p - package)
    (in ?p - package ?l - location)
    (connected ?from ?to - location)
    (requested ?p - package ?dest - location)
    (delivered ?p - package)
    (available ?a - agent)
  )

  (:action pick-up
    :parameters (?a - agent ?p - package ?l - location)
    :precondition (and
      (at ?a ?l)
      (in ?p ?l)
      (available ?a)
    )
    :effect (and
      (not (in ?p ?l))
      (has ?a ?p)
      (not (available ?a))
    )
  )

  (:action move
    :parameters (?a - agent ?from ?to - location)
    :precondition (and
      (at ?a ?from)
      (connected ?from ?to)
      (available ?a)
    )
    :effect (and
      (at ?a ?to)
      (not (at ?a ?from))
      (not (available ?a))
    )
  )

  (:action drop-off
    :parameters (?a - agent ?p - package ?l - location)
    :precondition (and
      (at ?a ?l)
      (has ?a ?p)
      (requested ?p ?l)
      (available ?a)
    )
    :effect (and
      (delivered ?p)
      (not (has ?a ?p))
      (not (available ?a))
    )
  )
)