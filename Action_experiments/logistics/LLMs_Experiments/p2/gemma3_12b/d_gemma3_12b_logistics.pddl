(define (domain logistics)
  (:requirements
    :strips
    :typing
    :disjunctive-preconditions
    :equality
    :conditional-effects
  )
  (:types
    location
    city
    physobj
    package
    vehicle
  )
  (:predicates
    (loc ?l - location ?c - city)
    (at ?x - physobj ?l - location)
    (in ?p - package ?v - vehicle)
  )

  (:action load
    :parameters (?p - package ?v - vehicle ?l - location)
    :precondition (and (at ?p ?l) (at ?v ?l) (not (in ?p ?v)))
    :effect (and (in ?p ?v) (not (at ?p ?l)))
  )

  (:action unload
    :parameters (?p - package ?v - vehicle ?l - location)
    :precondition (and (in ?p ?v) (at ?v ?l))
    :effect (and (at ?p ?l) (not (in ?p ?v)))
  )

  (:action drive
    :parameters (?v - vehicle ?l1 - location ?l2 - location ?c - city)
    :precondition (and (loc ?l1 ?c) (loc ?l2 ?c) (at ?v ?l1))
    :effect (and (at ?v ?l2) (not (at ?v ?l1)))
  )

  (:action fly
    :parameters (?a1 - location ?a2 - location)
    :precondition (at ?a1 ?a2)
    :effect (and (at ?a1 ?a2) (not (at ?a1 ?a2)))
  )
)
