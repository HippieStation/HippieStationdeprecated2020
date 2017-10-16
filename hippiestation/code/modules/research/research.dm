/datum/research/autolathe/atmoslathe/New()
	for(var/T in (subtypesof(/datum/tech)))
		possible_tech += new T(src)
	for(var/path in subtypesof(/datum/design))
		var/datum/design/D = new path(src)
		possible_designs += D
		if((D.build_type & ATMOSLATHE) && ("initial" in D.category))  //ATMOSLATHE starts without hacked designs
			AddDesign2Known(D)

/datum/research/autolathe/atmoslathe/AddDesign2Known(datum/design/D)
	if(!(D.build_type & ATMOSLATHE) || known_designs[D.id])
		return
	known_designs[D.id] = D
