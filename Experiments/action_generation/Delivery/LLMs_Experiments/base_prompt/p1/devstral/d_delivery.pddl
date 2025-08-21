(define (domain delivery)
  (:requirements :strips)

  (:types
    agent
    location
    package
  )

  (:predicates
    ; Agent at a location
    (at ?a - agent ?l - location)
    ; Agent has a package
    (has ?a - agent ?p - package)
    ; Package is at a location
    (in ?p - package ?l - location)
    ; Locations are directly connected
    (connected ?from ?to - location)
    ; Package needs to be delivered to destination
    (requested ?p - package ?dest - location)
    ; Package has been delivered
    (delivered ?p - package)
    ; Agent is available for tasks
    (available ?a - agent)
  )

  (:action pick-up
    :parameters (?a - agent ?l - location ?p - package)
    :precondition (and
                    (at ?a ?l)
                    (in ?p ?l)
                    (not (has ?a ?p))
                    (available ?a))
    :effect (and
              (has ?a ?p)
              (not (in ?p ?l))
              (not (available ?a)))
  )

  (:action move
    :parameters (?a - agent ?from ?to - location)
    :precondition (and
                    (at ?a ?from)
                    (connected ?from ?to))
    :effect (and
              (at ?a ?to)
              (not (at ?a ?from)))
  )

  (:action drop-off
    :parameters (?a - agent ?l - location ?p - package)
    :precondition (and
                    (at ?a ?l)
                    (has ?a ?p))
    :effect (and
              (in ?p ?l)
              (not (has ?a ?p))
              (delivered ?p)
              (available ?a))
  )
)