% Delivery Domain

% Predicates
(at ?a - agent ?l - location)
(has ?a - agent ?p - package)
(in ?p - package ?l - location)
(connected ?from ?to - location)
(requested ?p - package ?dest - location)
(delivered ?p - package)
(available ?a - agent)

% Actions

% pick-up
(define (pick-up ?p - package)
  (has (agent) ?p)
  (at (agent) ?p)
  (in ?p (at (agent)))
  (available (agent))
  (not (in ?p (at (agent))))
  (delivered ?p)
)

% move
(define (move ?from ?to)
  (at (agent) ?from)
  (connected ?from ?to)
  (available (agent))
  (not (at (agent) ?from))
)

% drop-off
(define (drop-off ?p - package)
  (has (agent) ?p)
  (at (agent) ?p)
  (in ?p (at (agent)))
  (requested ?p (at (agent)))
  (not (has (agent) ?p))
)