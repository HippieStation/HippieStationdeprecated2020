/datum/symptom/mind_restoration/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob


	if(A.stage >= 3)
		M.dizziness = max(0, M.dizziness - 2)
		M.drowsyness = max(0, M.drowsyness - 2)
		M.slurring = max(0, M.slurring - 2)
		M.confused = max(0, M.confused - 2)
		if(purge_alcohol)
			M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.drunkenness = max(H.drunkenness - 5, 0)

	if(A.stage >= 4)
		M.drowsyness = max(0, M.drowsyness - 2)
		if(M.reagents.has_reagent(/datum/reagent/toxin/mindbreaker))
			M.reagents.remove_reagent(/datum/reagent/toxin/mindbreaker, 5)
		if(M.reagents.has_reagent(/datum/reagent/toxin/histamine))
			M.reagents.remove_reagent(/datum/reagent/toxin/histamine, 5)
		M.hallucination = max(0, M.hallucination - 10)

	if(A.stage >= 5)
		M.adjustBrainLoss(-3)
		if(trauma_heal_mild && iscarbon(M))
			var/mob/living/carbon/C = M
			if(prob(40))
				if(trauma_heal_severe)
					C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_LOBOTOMY)
				else
					C.cure_trauma_type(resilience = TRAUMA_RESILIENCE_BASIC)