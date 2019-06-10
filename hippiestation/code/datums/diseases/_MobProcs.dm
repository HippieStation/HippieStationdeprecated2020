/mob/living/CanContractDisease(datum/disease/D)
	. = ..()
	if(count_by_type(diseases, /datum/disease/advance) >= 1)
		return FALSE