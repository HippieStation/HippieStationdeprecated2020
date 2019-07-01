/datum/chemical_reaction/sodawater
	name = "Sodafication"
	id = "sodafication"
	results = list(/datum/reagent/consumable/sodawater = 10)
	required_reagents = list(/datum/reagent/carbondioxide = 1, /datum/reagent/water = 10)
	pressure_required = 20 //the co2 needs to be under pressure to be solved in water
