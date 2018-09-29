/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(special_attack && iscarbon(user))
		var/mob/living/carbon/C = user

		if(C.getStaminaLoss() >= (100 - src.special_cost))
			to_chat(user,"<span class='warning'>You don't have enough stamina to do this!</span>")
			return FALSE

		if(do_special_attack(target, user, proximity_flag))
			C.adjustStaminaLoss(src.special_cost)
			playsound(user, 'hippiestation/sound/weapons/special.ogg',40, 1, 1)
			return
	return ..()
