(define domain delivery
  (:type domain)
  (:extend domain existing-domain)

  (:capability existing-domain)
  (:capability delivery)

  (:predicate pick-up
    :agent ?a
      :location ?l
      :package ?p
      :available ?a
    :and
    :package in ?l)

  (:predicate move
    :agent ?a
      :source-location ?l
      :locations connected ?from ?to
      :available ?a
      :and
      :package requested-to ?dest)

  (:predicate drop-off
    :agent ?a
      :package ?p
      :destination ?dest
      :available ?a
      :and
      :package delivered-from ?l)
)