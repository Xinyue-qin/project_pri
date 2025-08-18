(define (problem partial-goal)
  (:domain blocksworld-4ops)
  (:objects A B C D - block)
  (:init (arm-empty)
         (on-table A) (on-table B) (on-table C) (on-table D)
         (clear A) (clear B) (clear C) (clear D))
  (:goal (and (on A B) (on C D))))  ; Note: No specification for other blocks