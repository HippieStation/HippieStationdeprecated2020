/datum/reagent/consumable/condensedcapsaicin/reaction_turf(turf/T, reac_volume)
  return

  /datum/reagent/consumable/nutriment/vitamin/on_mob_life(mob/living/carbon/M)
	if(M.satiety < 569)
		M.satiety += 30
	. = ..()
