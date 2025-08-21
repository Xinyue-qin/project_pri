(define (domain blocksworld-4ops)

  (:requirements :strips)

  (:predicates
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )

  (:action pickup
    :parameters (?x - block)
    :precondition (and (clear ?x - block) (arm-empty))
    :effect (and (holding ?x - block) (not (arm-empty)) (not (clear ?x - 
block)))
  )

  (:action putdown
    :parameters (?x - block)
    :precondition (holding ?x - block)
    :effect (and (arm-empty) (not (holding ?x - block)) (clear ?x - 
block))
  )

  (:action stack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x - block) (on ?y - block) (on ?x - block 
?y - block))
    :effect (and (arm-empty) (not (holding ?x - block)) (not (on ?x - 
block ?y - block)) (clear ?y - block))
  )

  (:action unstack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x - block) (on ?x - block ?y - block) (on 
?y - block))
    :effect (and (arm-empty) (not (holding ?x - block)) (not (on ?x - 
block ?y - block)) (clear ?y - block))
  )
)