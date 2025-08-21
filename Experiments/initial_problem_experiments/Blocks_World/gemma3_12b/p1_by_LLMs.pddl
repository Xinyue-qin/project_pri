(define (problem simple-stack)
  (:domain blocksworld-4ops)
  (:objects A B C - block)
  (:init (on-table A) (on-table B) (on-table C)
         (clear A) (clear B) (clear C)
         (arm-empty)) ;Crucially add arm-empty
  (:goal (and (on A B) (on B C) (on-table C))))