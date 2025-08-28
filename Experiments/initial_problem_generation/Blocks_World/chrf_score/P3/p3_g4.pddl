(define (problem complex-rearrange-alt)
  (:domain blocksworld-4ops)
  (:objects A B C D
 - block)
  (:init (arm-empty) (on B A) (clear B) (on D C) (clear D) (on-table A))
  (:goal (and (on A B) (on B C) (on C D) (on-table D))))