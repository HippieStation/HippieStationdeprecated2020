/mob/living/CanContractDisease(datum/disease/D)
	. = ..()
	if(istype(D, /datum/disease/advance) && count_by_type(diseases, /datum/disease/advance) >= 1)
		return FALSE
