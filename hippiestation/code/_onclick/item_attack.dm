/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(special_attack && iscarbon(user))
		var/mob/living/carbon/C = user

		if(C.getStaminaLoss() >= (100 - src.special_cost))
			to_chat(user,"<span class='warning'>You don't have enough stamina to do this!</span>")
			return FALSE

		var/can_ult = TRUE
		if(is_ganymede())
			can_ult = FALSE
		if(can_ult && do_special_attack(target, user, proximity_flag))
			C.adjustStaminaLoss(src.special_cost)
			playsound(user, 'hippiestation/sound/weapons/special.ogg',40, 1, 1)
			return
	return ..()

/obj/item/melee_attack_chain(mob/user, atom/target, params)
	. = ..()
	SSdemo.mark_dirty(src)
	if(isturf(target))
		SSdemo.mark_turf(target)
	else
		SSdemo.mark_dirty(target)

/obj/item/attack_self(mob/user)
	. = ..()
	SSdemo.mark_dirty(src)
