(define blocksworld-4ops
  (:type system:process-action)
  (:extend-domain blocksworld)
  (:extend-predicates blocksworld-4ops
    (arm-empty ?)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
    (putdown ?x - block)
    (pickup ?x - block)
    (stack ?x - block)
    (unstack ?x - block)
  ))