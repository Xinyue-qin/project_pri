(define (problem tower-reversal-complete)
  (:domain blocksworld-4ops)
  (:objects A B C - block)
  (:init
    (arm-empty)           ; Arm is empty
    (on B A)
    (on C B)
    (clear C)
    (not (on-table A))    ; Not on table, because it's on B
    (not (on-table B))    ; Not on table, because it's on C
  )
  (:goal (and (on-table C) (on B C) (on A B)))
)