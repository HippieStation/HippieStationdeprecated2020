/datum/magic
	var/name
	var/complexity = 1
	var/antimagic_interaction = ANTIMAGIC_NULLIFY
	var/residual_cost = 5

/datum/magic/proc/fire(mob/living/firer)

/datum/magic/proc/misfire(mob/living/firer, amped = FALSE)

/datum/magic/proc/should_reject(mob/living/firer)
	. = FALSE
	if(ishuman(firer))
		var/mob/living/carbon/human/H = firer
		if(H.dna && LAZYLEN(H.dna.mutations))
			for(var/datum/mutation/human/M in H.dna.mutations)
				if(M.quality == POSITIVE)
					return TRUE // haha sucks to be you

/datum/magic/proc/reject(mob/living/firer)
