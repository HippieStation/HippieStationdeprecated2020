/datum/martial_art
	var/mob/living/carbon/human/owner // was it this fucking hard to add a simple link to the human?

/datum/martial_art/teach(mob/living/carbon/human/H,make_temporary=0)
	. = ..()
	if(.)
		owner = H

/datum/martial_art/remove(mob/living/carbon/human/H)
	reset_streak() // just in case
	owner = null
	..()

/datum/martial_art/add_to_streak(element,mob/living/carbon/human/D)
	..()
	addtimer(CALLBACK(src, .proc/reset_streak), 100, TIMER_OVERRIDE|TIMER_UNIQUE)

/datum/martial_art/proc/reset_streak()
	if(owner && owner.client && owner.hud_used)
		if(owner.hud_used.combo_object)
			owner.hud_used.combo_object.reset_streak()
			streak = ""
