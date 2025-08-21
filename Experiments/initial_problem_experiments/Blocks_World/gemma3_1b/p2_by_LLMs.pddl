(define (domain blocksworld-4ops)
  (:requirements :strips)

  ;; Predicates
  (:predicates
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )

  ;; Action: putdown
  (:action putdown
    :parameters (?x - block)
    :precondition (and (holding ?x))
    :effect (and
              (not (holding ?x))
              (arm-empty)
              (clear ?x)
              (on-table ?x)
            )
  )

  ;; Action: pickup
  (:action pickup
    :parameters (?x - block)
    :precondition (and (arm-empty) (clear ?x) (on-table ?x))
    :effect (and
              (not (arm-empty))
              (holding ?x)
              (not (clear ?x))
            )
  )

  ;; Action: stack
  (:action stack
    :parameters (?x - block ?y - block)
    :precondition (and (holding ?x) (clear ?y))
    :effect (and
              (not (holding ?x))
              (arm-empty)
              (on ?x ?y)
              (clear ?x)
              (not (clear ?y))
            )
  )

  ;; Action: unstack
  (:action unstack
    :parameters (?x - block ?y - block)
    :precondition (and (arm-empty) (on ?x ?y) (clear ?x))
    :effect (and
              (not (arm-empty))
              (holding ?x)
              (clear ?y)
              (not (on ?x ?y))
            )
  )
)