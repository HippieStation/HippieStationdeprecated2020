/mob/living/carbon/damage_eyes(amount)
	if(status_flags & GODMODE)
		return
	..()

/mob/living/carbon/adjust_eye_damage(amount)
	if(status_flags & GODMODE)
		return
	..()

/mob/living/carbon/set_eye_damage(amount)
	if(status_flags & GODMODE)
		return
	..()