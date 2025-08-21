(define (problem multi-tower)
  (:domain blocksworld-4ops)
  (:objects A B C D E - block)
  (:init
    (on-table A)   ; Initially, A is on the table
    (on-table B)   ; Initially, B is on the table
    (clear C)      ; C is clear and not holding any blocks
    (on-table D)   ; Initially, D is on the table
    (on-table E)   ; Initially, E is on the table, ready for stacking
  )
  (:goal (and
          (on A C)
          (on-table C)
          (on B E)
          (on-table E)
          (on D B)))
)