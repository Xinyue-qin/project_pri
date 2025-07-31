(define (domain blocksworld-4ops)

(:requirements :typing)
(:types block) 

(:predicates (clear ?x - block)
             (on-table ?x - block)
             (arm-empty)
             (holding ?x - block)
             (on ?x ?y - block))

(define (action putdown
  :parameters (?x - block)
  :precondition (holding ?x)
  :effect (and (arm-empty) (on-table ?x)))
(define (action pickup
  :parameters (?x - block)
  :precondition (and (arm-empty) (on-table ?x) (clear ?x))
  :effect (and (holding ?x) (not (on-table ?x)) (not (clear ?x))))
(define (action stack
  :parameters (?x - block ?y - block)
  :precondition (and (holding ?x) (clear ?y))
  :effect (and (on ?x ?y) (arm-empty) (not (holding ?x)) (not (clear 
?y))))
(define (action unstack
  :parameters (?x - block ?y - block)
  :precondition (and (on ?x ?y) (clear ?x) (arm-empty))
  :effect (and (holding ?x) (clear ?y) (not (on ?x ?y)) (not 
(arm-empty)))))))))