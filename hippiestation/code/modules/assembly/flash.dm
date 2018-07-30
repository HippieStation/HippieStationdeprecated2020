/obj/item/assembly/flash/AOE_flash/(bypass_checks = FALSE, range = 3, power = 5, targeted = FALSE, mob/user)
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	if(user)
		targets -= user
	for(var/mob/living/carbon/C in targets)
		if(C.eye_blind)
			return FALSE
	..()

/obj/item/assembly/flash/flash_carbon/(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(M.eye_blind)
		return FALSE
	..()