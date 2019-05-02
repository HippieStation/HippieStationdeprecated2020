/datum/species/moth
	name = "Mothmen"
	mutanteyes = /obj/item/organ/eyes

/datum/species/moth/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!H.dna.features["moth_wings"])
			H.dna.features["moth_wings"] = "[(H.client && H.client.prefs && LAZYLEN(H.client.prefs.features) && H.client.prefs.features["moth_wings"]) ? H.client.prefs.features["moth_wings"] : "Plain"]"
			handle_mutant_bodyparts(H)

/datum/species/moth/check_roundstart_eligible()
	return TRUE
