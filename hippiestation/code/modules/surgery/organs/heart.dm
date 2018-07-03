/obj/item/organ/heart/Remove(mob/living/carbon/M, special = 0)
	..()
	var/mob/living/carbon/human/user = M
	user.set_heartattack(TRUE)
	if(!special)
		addtimer(CALLBACK(src, .proc/stop_if_unowned), 120)