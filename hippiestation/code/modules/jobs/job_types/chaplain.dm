/datum/outfit/job/chaplain/post_equip(mob/living/carbon/human/H)
	..()
	H.dna.add_mutation(ANTIMAGICMUT)
	for(var/datum/mutation/human/M in H.dna.mutations)
		if(istype(M, /datum/mutation/human/antimagic))
			M.mutadone_proof = TRUE
