(define (action putdown)
  (:predicate action)
  (:domain blocksworld-4ops)
  (:specifier action)
  (:type action)
  (:specifier
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )
  (:body
    (define arm-position (get-arm-position))
    (define block-position (get-block-position))
    (put-down-block block-position)
  )
)

(define (action pickup)
  (:predicate action)
  (:domain blocksworld-4ops)
  (:specifier action)
  (:type action)
  (:specifier
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )
  (:body
    (define arm-position (get-arm-position))
    (define block-position (get-block-position))
    (pickup-block block-position)
  )
)

(define (action stack)
  (:predicate action)
  (:domain blocksworld-4ops)
  (:specifier action)
  (:type action)
  (:specifier
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )
  (:body
    (define arm-position (get-arm-position))
    (define block-position (get-block-position))
    stack-blocks block-position, block-position)
)

(define (action unstack)
  (:predicate action)
  (:domain blocksworld-4ops)
  (:specifier action)
  (:type action)
  (:specifier
    (arm-empty)
    (holding ?x - block)
    (clear ?x - block)
    (on ?x - block ?y - block)
    (on-table ?x - block)
  )
  (:body
    (define arm-position (get-arm-position))
    (define block-position (get-block-position))
    unstack-blocks block-position, block-position)
)

(define (get-arm-position)
  (:predicate action)
  (:specifier action)
  (:type action)
  (:body
    (define arm-position (get-arm-position))
  )
)

(define (get-block-position)
  (:predicate action)
  (:specifier action)
  (:type action)
  (:body
    (get-block-position))
)

(define (get-arm-empty)
  (:predicate action)
  (:specifier action)
  (:type action)
  (:body
    (get-arm-empty))

(define (get-block-empty)
  (:predicate action)
  (:specifier action)
  (:type action)
  (:body
    (get-block-empty))
)

(define (get-on-table)
  (:predicate action)
  (:specifier action)
  (:type action)
  (:body
    (get-on-table))
)


(define (get-on)
  (:predicate action)
  (:specifier action)
  (:type action)
  (:body
    (get-on))
)