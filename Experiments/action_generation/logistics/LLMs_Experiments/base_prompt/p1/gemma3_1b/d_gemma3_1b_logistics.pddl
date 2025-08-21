(define domain logistics
  (:property introduce 'location)
  (:init 'location 'NewYork)
  (:species logistics)
  (:specifications (:logistics location 'NewYork)))

(define action load
  (:intent 'move)
  (:specifies 'location 'NewYork)
  (:precondition 'object 'package)
  (:effect 'vehicle 'truck)
  (:extend 'vehicle 'truck 'NewYork'))

(define action unload
  (:intent 'remove)
  (:specifies 'location 'NewYork)
  (:precondition 'object 'vehicle)
  (:effect 'vehicle 'truck)
  (:extend 'vehicle 'truck 'NewYork'))

(define action drive
  (:intent 'move)
  (:specifies 'location 'Unknown)
  (:precondition 'vehicle 'truck)
  (:effect 'truck 'location 'NewYork'))

(define action fly
  (:intent 'move)
  (:specifies 'location 'Unknown)
  (:precondition 'airplane 'truck)
  (:effect 'airplane 'location 'NewYork'))

(define action locate
  (:intent 'find)
  (:specifies 'location 'NewYork)
  (:precondition 'object 'truck)
  (:effect 'truck 'location 'NewYork'))