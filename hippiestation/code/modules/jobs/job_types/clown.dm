/datum/outfit/job/clown/post_equip(mob/living/carbon/human/H)
	..()
	for(var/datum/mutation/human/M in H.dna.mutations)
		if(istype(M, /datum/mutation/human/clumsy))
			M.mutadone_proof = TRUE
