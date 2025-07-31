(define (problem letseat-simple)
	(:domain letseat)
	(:objects
	arm - robot
	cupcake1 cupcake2 - cupcake
	table - location
	plate - location
	)

	(:init
		(on arm table)
		(on cupcake1 table)
		(on cupcake2 table)
		(arm-empty)
		(path table plate)
		(path plate table)
		(path table cupcake1)
		(path cupcake1 table)
		(path cupcake2 table)
		(path table cupcake2)
		(path cupcake1 cupcake2)
		(path cupcake2 cupcake1)
	)
	(:goal (and
		(on cupcake1 plate)
		(on cupcake2 cupcake1))
	)
)
