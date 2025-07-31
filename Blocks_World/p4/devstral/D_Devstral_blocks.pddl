(define (domain blocksworld-4ops)

(:requirements :typing)
(:types block) 

(:predicates (clear ?x - block)
             (on-table ?x - block)
             (arm-empty)
             (holding ?x - block)
             (on ?x ?y - block))

(action pickup
  :parameters (?x - block)
  :precondition (and (on-table ?x) (clear ?x) (arm-empty))
  :effect (and (not (on-table ?x)) (not (clear ?x)) (holding ?x))
)

(action putdown
  :parameters (?x - block)
  :precondition (and (holding ?x))
  :effect (and (not (holding ?x)) (on-table ?x) (clear ?x) (arm-empty))
)

(action stack
  :parameters (?x - block ?y - block)
  :precondition (and (holding ?x) (clear ?y))
  :effect (and (not (holding ?x)) (on ?x ?y) (clear ?x) (arm-empty))
)

(action unstack
  :parameters (?x - block ?y - block)
  :precondition (and (on ?x ?y) (clear ?x) (arm-empty))
  :effect (and (not (on ?x ?y)) (not (clear ?x)) (holding ?x) (clear ?y))
))