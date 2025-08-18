(define (domain logistics)
  (:requirements :strips :typing)
  (:types city location physobj vehicle package airport)
  (:predicates
    (loc ?l - location ?c - city)
    (at ?x - physobj ?l - location)
    (in ?p - package ?v - vehicle)
  )

  (:action load
    :parameters (?p - package ?v - vehicle ?l - location)
    :precondition (and (at ?p ?l) (at ?v ?l))
    :effect (and (not (at ?p ?l)) (in ?p ?v))
  )

  (:action unload
    :parameters (?p - package ?v - vehicle ?l - location)
    :precondition (and (in ?p ?v) (at ?v ?l))
    :effect (and (not (in ?p ?v)) (at ?p ?l))
  )

  (:action drive
    :parameters (?v - vehicle ?from - location ?to - location ?c - city)
    :precondition (and (at ?v ?from) (loc ?from ?c) (loc ?to ?c))
    :effect (and (not (at ?v ?from)) (at ?v ?to))
  )

  (:action fly
    :parameters (?v - vehicle ?from - location ?to - location)
    :precondition (at ?v ?from)
    :effect (and (not (at ?v ?from)) (at ?v ?to))
  )
)