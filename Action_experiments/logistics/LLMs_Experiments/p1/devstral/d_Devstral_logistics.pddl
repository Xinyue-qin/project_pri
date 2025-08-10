(define (domain logistics)
  (:requirements :strips)

  ;; Predicates
  (:predicates
    (loc ?l - location ?c - city)        ; A location l is in a city c.
    (at ?x - physobj ?l - location)      ; A physical object x is at a location l.
    (in ?p - package ?v - vehicle)       ; A package p is in a vehicle v.
  )

  ;; Actions
  (:action load
    :parameters (?o - package ?v - truck ?l - location)
    :precondition (and (at ?o ?l) (at ?v ?l))
    :effect (and (not (at ?o ?l)) (in ?o ?v))
  )

  (:action unload
    :parameters (?o - package ?v - truck ?l - location)
    :precondition (and (in ?o ?v) (at ?v ?l))
    :effect (and (not (in ?o ?v)) (at ?o ?l))
  )

  (:action drive
    :parameters (?t - truck ?from - location ?to - location ?c - city)
    :precondition (and (loc ?from ?c) (loc ?to ?c) (at ?t ?from))
    :effect (and (not (at ?t ?from)) (at ?t ?to))
  )

  (:action fly
    :parameters (?a - airplane ?from - location ?to - location)
    :precondition (and (at ?a ?from) (loc ?from airport) (loc ?to airport))
    :effect (and (not (at ?a ?from)) (at ?a ?to))
  )
)
