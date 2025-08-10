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
    :precondition (and (holding ?x))
    :effect (and (not (holding ?x))
                (clear ?x)))
)

(define (action pickup
    :parameters (?x - block)
    :precondition (and (arm-empty)
                    (clear ?x))
    :effect (and (not (arm-empty))
                (holding ?x)
                (not (clear ?x))))
)

(define (action stack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x)
                    (clear ?y))
    :effect (and (not (holding ?x))
                (on ?x ?y)
                (clear ?x)
                (not (clear ?y))))
)

(define (action unstack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x)
                    (on ?x ?y)
                    (clear ?x))
    :effect (and (not (holding ?x))
                (clear ?y)
                (not (on ?x ?y))))
))