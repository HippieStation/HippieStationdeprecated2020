/datum/job/proc/hippie_after_spawn(mob/living/carbon/human/H, mob/M) // because /tg/'s version is empty and the childs don't call ..()
	if(!H || !M)
		return FALSE
	if(jobban_isbanned(M, CATBAN))
		H.set_species(/datum/species/tarajan) // can't escape hell
