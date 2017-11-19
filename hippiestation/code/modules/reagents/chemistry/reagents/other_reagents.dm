/datum/reagent/fuel/unholywater/on_mob_life(mob/living/M)
	if(iscultist(M))
		M.drowsyness = max(M.drowsyness-5, 0)
		M.adjustToxLoss(-3, 0)
		M.adjustOxyLoss(-3, 0)
		M.adjustBruteLoss(-3, 0)
		M.adjustFireLoss(-3, 0)
		M.adjustCloneLoss(-5, 0)
		M.adjustBrainLoss(-3, 0)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.blood_volume < BLOOD_VOLUME_NORMAL)
				C.blood_volume += 5
	else
		M.adjustBrainLoss(3)
		M.adjustToxLoss(1, 0)
		M.adjustFireLoss(2, 0)
		M.adjustOxyLoss(2, 0)
		M.adjustBruteLoss(2, 0)
	holder.remove_reagent(src.id, 1)
	return FINISHONMOBLIFE(M)

/datum/reagent/water/reaction_turf(turf/open/T, reac_volume)
	. = ..()
	for(var/mob/living/simple_animal/hostile/gremlin/G in src)
		G.divide()

/datum/reagent/water/on_mob_life(mob/living/M)
	M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 1*REM, 0, 1)
	M.adjustToxLoss(-0.2*REM, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.drunkenness = max(H.drunkenness - 2, 0)
	..()
	. = 1
