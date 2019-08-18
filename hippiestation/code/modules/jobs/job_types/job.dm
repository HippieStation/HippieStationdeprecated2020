/datum/job/proc/hippie_after_spawn(mob/living/carbon/human/H, mob/M) // because /tg/'s version is empty and the childs don't call ..()
	if(!H || !M)
		return FALSE
	if(is_banned_from(M.ckey, CRABBAN))
		if(!SSticker.HasRoundStarted())
			SSticker.OnRoundstart(CALLBACK(H, /mob/living/carbon/human.proc/change_mob_type, /mob/living/simple_animal/crab, null, H.real_name, TRUE)) // where's my antag token
		else
			addtimer(CALLBACK(H, /mob/living/carbon/human.proc/change_mob_type, /mob/living/simple_animal/crab, null, H.real_name, TRUE), 5 SECONDS)
		H.set_species(/datum/species/tarajan) // can't escape hell
