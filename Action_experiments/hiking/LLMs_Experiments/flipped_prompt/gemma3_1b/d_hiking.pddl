(define domain hiking
  (:type domain:domain)

  (:extend domain hiking :parent domain-root)

  (:requirements 'bounding-box)
  (:type :object)
  (:recursiveness true)

  (:predicates
    (at ?h - hiker ?l - location)
    (rained ?l - location)
    (has-energy ?h - hiker)
    (path-clear ?from ?to - location)
  )

  (:actions
    (walk ?h ?l ?to - location)
    (rest ?h - hiker)
    (check-weather ?l - location)
  )
)