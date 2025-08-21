(define hiking
  (domain hiking))

(define action walk
  (begin
    (predicate (at ?h ?l)
      (and
        (has-energy ?h)
        (path-clear ?from ?to)
        (action walk))
  ))

(define action rest
  (predicate (rained ?l)
    (action rest))
)

(define action check-weather
  (predicate (has-energy ?h)
    (action check-weather))
)