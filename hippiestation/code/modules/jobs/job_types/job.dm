/datum/job/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null)
	if(!H)
		return FALSE
	if(jobban_isbanned(H, CATBAN))
		H.set_species(/datum/species/tarajan, icon_update=1) // can't escape hell
	..()