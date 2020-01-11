/datum/chemical_reaction/plasmasolidification
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/toxin/plasma = 20)

/datum/chemical_reaction/silversolidification
	name = "Solid Silver"
	id = "solidsilver"
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/silver = 20)
	mob_react = FALSE

/datum/chemical_reaction/silversolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/mineral/silver(location)

/datum/chemical_reaction/metalsolidification
	name = "Solid metal"
	id = "solidmetal"
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/iron = 20)
	mob_react = FALSE

/datum/chemical_reaction/metalsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/metal(location)

/datum/chemical_reaction/glasssolidification
	name = "Solid Glass"
	id = "solidglass"
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/silicon = 20)
	mob_react = FALSE

/datum/chemical_reaction/glasssolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/glass(location)

/datum/chemical_reaction/goldsolidification
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/gold = 20)

/datum/chemical_reaction/uraniumsolidification
	name = "Solid Uranium"
	id = "soliduranium"
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/uranium = 20)
	mob_react = FALSE

/datum/chemical_reaction/uraniumsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/mineral/uranium(location)

/datum/chemical_reaction/bananasolidification
	name = "Solid Bananium"
	id = "solidbanana"
	required_reagents = list(/datum/reagent/pyrosium = 5, /datum/reagent/cryostylane = 5, /datum/reagent/consumable/banana = 80)//There is 1000u of banana juice on station at roundstart, an enterpirsing robitisict could have a honk up every round if I kept it the same.
	mob_react = FALSE

/datum/chemical_reaction/bananasolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/mineral/bananium(location)

/datum/chemical_reaction/plastic_polymers
	required_reagents = list(/datum/reagent/oil = 5, /datum/reagent/consumable/sodiumchloride = 2, /datum/reagent/ash = 3)
	required_temp = 330 //lowered required temp so that we don't get that damn stuff turning to charcoal instead

/datum/chemical_reaction/plastic_polymers/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/plastic(location)

/datum/chemical_reaction/randonium
	name = "Randonium"
	id = "randonium"
	results = list(/datum/reagent/randonium = 3)
	required_reagents = list(/datum/reagent/consumable/lean = 1, /datum/reagent/drug/methamphetamine = 1, /datum/reagent/teslium = 1)
	mix_message = "<span class='danger'>The solution sparks and freezes, then suddenly turns back to liquid!</span>"
	pressure_required = 25

/datum/chemical_reaction/randonium/on_reaction(datum/reagents/holder)
	..()
	var/turf/open/T = get_turf(holder.my_atom)
	do_sparks(8,1,T)
	explosion(0,0,0,3)
	tesla_zap(T, 10, 5000, TESLA_MOB_DAMAGE | TESLA_OBJ_DAMAGE | TESLA_MOB_STUN | TESLA_ALLOW_DUPLICATES)	//Big zap boy
	playsound(T, 'sound/magic/lightningshock.ogg', 50, 1)



/datum/chemical_reaction/sharplipium
	name = "Sharplipium"
	required_reagents = list(/datum/reagent/silver = 1, /datum/reagent/iron = 1, /datum/reagent/medicine/ephedrine = 1, /datum/reagent/drug/space_drugs = 1)
	results = list(/datum/reagent/sharplipium = 3)
