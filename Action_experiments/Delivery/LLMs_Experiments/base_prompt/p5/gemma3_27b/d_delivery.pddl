(define (domain delivery)
  (:requirements :strips :typing)
  (:types agent location package)

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
                    (requested ?p ?l)
                    (available ?a)
                  )
    :effect (and
              (has ?a ?p)
              (not (in ?p ?l))
              (not (available ?a))
              (not (requested ?p ?l))
            )
  )

  (:action move
    :parameters (?a - agent ?from - location ?to - location)
    :precondition (and
                    (at ?a ?from)
                    (connected ?from ?to)
                  )
    :effect (and
              (not (at ?a ?from))
              (at ?a ?to)
            )
  )

  (:action drop-off
    :parameters (?a - agent ?p - package ?dest - location)
    :precondition (and
                    (at ?a ?dest)
                    (has ?a ?p)
                    (requested ?p ?dest)
                  )
    :effect (and
              (not (has ?a ?p))
              (in ?p ?dest)
              (delivered ?p)
              (available ?a)
            )
  )
)