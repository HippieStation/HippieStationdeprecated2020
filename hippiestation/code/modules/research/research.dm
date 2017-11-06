/datum/research/reagent_forge/New()
	for(var/T in (subtypesof(/datum/tech)))
		possible_tech += new T(src)
	for(var/path in subtypesof(/datum/design))
		var/datum/design/D = new path(src)
		possible_designs += D
		if((D.build_type & REAGENT_FORGE) && ("initial" in D.category))  //ATMOSLATHE starts without hacked designs
			AddDesign2Known(D)

/datum/research/reagent_forge/AddDesign2Known(datum/design/D)
	if(!(D.build_type & REAGENT_FORGE) || known_designs[D.id])
		return
	known_designs[D.id] = D
