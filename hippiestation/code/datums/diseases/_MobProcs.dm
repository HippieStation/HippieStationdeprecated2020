/mob/living/CanContractDisease(datum/disease/D)
	. = ..()
	if(count_by_type(diseases, /datum/disease/advance) >= 3)
		return FALSE