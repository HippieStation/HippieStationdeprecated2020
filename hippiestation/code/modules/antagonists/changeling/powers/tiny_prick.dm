/datum/action/changeling/sting
	var/sting_icon_hippie = null

/datum/action/changeling/sting/fart
	name = "Fart Sting"
	desc = "We silently sting a human with a cocktail of chemicals that will make them fart like they ate chipotle.."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly blowing up the air around them."
	sting_icon_hippie = "sting_fart"
	chemical_cost = 15
	dna_cost = 0

/datum/action/changeling/sting/fart/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", "fart sting")
	if(target.reagents)
		target.reagents.add_reagent("fartium", 35) // overdoses on fartium. won't cause damage, but will cause large amounts of farting.
	return TRUE
