(define (domain delivery)
  (:requirements :strips :typing)

  (:types
    agent package location - object
  )

  (:predicates
    (at ?a - agent ?l - location)
    (has ?a - agent ?p - package)
    (in ?p - package ?l - location)
    (connected ?from - location ?to - location)
    (requested ?p - package ?dest - location)
    (delivered ?p - package)
    (available ?a - agent)
  )

  (:action pick-up
    :parameters (?a - agent ?p - package ?l - location)
    :precondition (and (at ?a ?l) (in ?p ?l) (available ?a))
    :effect (and 
              (has ?a ?p)
              (not (in ?p ?l))
            )
  )

  (:action move
    :parameters (?a - agent ?from - location ?to - location)
    :precondition (and (at ?a ?from) (connected ?from ?to) (available ?a))
    :effect (and 
              (at ?a ?to)
              (not (at ?a ?from)))
  )

  (:action drop-off
    :parameters (?a - agent ?p - package ?l - location)
    :precondition (and (has ?a ?p) (at ?a ?l) (requested ?p ?l))
    :effect (and 
              (delivered ?p)
              (in ?p ?l)
              (not (has ?a ?p)))
            )
  )
