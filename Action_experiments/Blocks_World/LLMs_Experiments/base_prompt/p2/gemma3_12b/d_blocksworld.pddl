(define (domain blocksworld-4ops)
  (:requirements :strips :typing)
  (:types block)

  (:predicates
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )

  (:action putdown
    :parameters (?x - block)
    :precondition (and (holding ?x))
    :effect (and (not (holding ?x)) (arm-empty) (clear ?x))
  )

  (:action pickup
    :parameters (?x - block)
    :precondition (and (arm-empty) (clear ?x))
    :effect (and (holding ?x) (not (arm-empty)) (not (clear ?x)))
  )

  (:action stack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x) (clear ?y))
    :effect (and (on ?x ?y) (clear ?x) (not (clear ?y)) (not (holding ?x)) 
(arm-empty))
  )

  (:action unstack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x) (on ?x ?y) (clear ?x))
    :effect (and (clear ?y) (not (clear ?x)) (not (holding ?x)) 
(arm-empty) (not (on ?x ?y)))
  )
)