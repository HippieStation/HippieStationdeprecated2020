/mob/living/carbon/human/grabbedby(mob/living/user, supress_message = 0)
	if (checkbuttinspect(user))
		return FALSE

	return ..()

/mob/living/carbon/human/check_block()
	if(mind)
		if(mind.martial_art && prob(mind.martial_art.constant_block) && mind.martial_art.can_use(src) && !incapacitated(FALSE, TRUE))
			return TRUE
	..()