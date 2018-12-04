/datum/reagent/consumable/condensedcapsaicin/reaction_turf(turf/T, reac_volume)
  return

/datum/reagent/consumable/nutriment/vitamin/on_mob_life(mob/living/carbon/M)
	if(M.satiety < 570)
		M.satiety += 30
	..()
