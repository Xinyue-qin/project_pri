(define (domain blocksworld-4ops)

(:requirements :typing)
(:types block) 

(:predicates (clear ?x - block)
             (on-table ?x - block)
             (arm-empty)
             (holding ?x - block)
             (on ?x ?y - block))

action pickup
  parameters:
    - x: block
  preconditions:
    - (clear ?x - block)
  effects:
    - (holding ?x - block)

action putdown
  parameters:
    - x: block
  preconditions:
    - (holding ?x - block)
  effects:
    - (arm-empty)
    - (clear ?x - block)

action stack
  parameters:
    - x: block
    - y: block
  preconditions:
    - (holding ?x - block)
    - (on-table ?y - block)
  effects:
    - (on ?x - block ?y - block)
    - (arm-empty)

action unstack
  parameters:
    - x: block
    - y: block
  preconditions:
    - (on ?x - block ?y - block)
  effects:
    - (holding ?x - block)
    - (clear ?y - block))