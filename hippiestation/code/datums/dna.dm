/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	..()
	update_teeth()
	if(jobban_isbanned(src, CATBAN) && dna.species.name != "Catbeast")
		set_species(/datum/species/tarajan, icon_update=1) // can't escape hell

/datum/dna/remove_mutation(mutation_name)
	..()
	if(jobban_isbanned(holder, CLUWNEBAN) && !check_mutation(CLUWNEMUT))
		add_mutation(CLUWNEMUT) // you can't escape hell

/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	if(jobban_isbanned(src, CATBAN))
		if(mrace != /datum/species/tarajan)
			set_species(/datum/species/tarajan)
			return
	..()