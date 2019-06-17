/datum/chemical_reaction/aluminiumf
	name = "Aluminium fluorate"
	id = "aluminiumf"
	results = list(/datum/reagent/medicine/aluminiumf = 4, /datum/reagent/toxin/goop = 2)
	required_reagents = list(/datum/reagent/toxin/carbonf = 2, /datum/reagent/oxygen = 2, /datum/reagent/aluminium = 2)
	required_temp = 230
	pressure_required = 25
	is_cold_recipe = TRUE

/datum/chemical_reaction/sodiumf
	name = "Sodium fluoride"
	id = "sodiumf"
	results = list(/datum/reagent/medicine/sodiumf = 4, /datum/reagent/toxin/goop = 3)
	required_reagents = list(/datum/reagent/toxin/carbonf = 2, /datum/reagent/sodium = 4)
	required_temp = 470

/datum/chemical_reaction/virogone
	name = "Cyclo-bromazine"
	id = "virogone"
	results = list(/datum/reagent/medicine/virogone = 2, /datum/reagent/toxin/mutagen = 2)
	required_reagents = list(/datum/reagent/medicine/aluminiumf = 2, /datum/reagent/medicine/sodiumf = 3)
	pressure_required = 76

/datum/chemical_reaction/over_reactible/superzine//no longer requires heat due to annoying meth explosions
	name = "Superzine"
	id = "superzine"
	results = list(/datum/reagent/medicine/superzine = 6, /datum/reagent/dizinc = 2)
	required_catalysts = list(/datum/reagent/toxin/mutagen = 5)
	required_reagents = list(/datum/reagent/drug/methamphetamine = 2, /datum/reagent/hexamine = 2, /datum/reagent/medicine/virogone = 2)
	pressure_required = 78
	can_overpressure = TRUE
	overpressure_threshold = 90

/datum/chemical_reaction/defib
	name = "Exstatic mixture"
	id = "defib"
	results = list(/datum/reagent/medicine/defib = 4, /datum/reagent/toxin/radgoop = 4)
	required_reagents = list(/datum/reagent/sparky = 2, /datum/reagent/toxin/carbonf = 2, /datum/reagent/medicine/virogone = 2)
	pressure_required = 70

/datum/chemical_reaction/liquid_life
	name = "Liquid life"
	id = "liquid_life"
	results = list(/datum/reagent/medicine/liquid_life = 3, /datum/reagent/toxin/methphos = 2)
	required_reagents = list(/datum/reagent/medicine/superzine = 1, /datum/reagent/medicine/virogone = 1, /datum/reagent/medicine/defib = 1)
	bluespace_recipe = TRUE

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	id = "kelotane"
	results = list(/datum/reagent/medicine/kelotane = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/silicon = 1)
