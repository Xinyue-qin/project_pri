(define (domain blocksworld-4ops)

(:requirements :typing)
(:types block) 

(:predicates (clear ?x - block)
             (on-table ?x - block)
             (arm-empty)
             (holding ?x - block)
             (on ?x ?y - block))

activate(robot_arm)
    where:
        robot_arm = {
            “arm-empty” = true
            “holding ?x - block” = true
            “clear ?x - block” = true
            “on ?x - block ?y - block” = true
            “on-table ?x - block” = true
        }
)