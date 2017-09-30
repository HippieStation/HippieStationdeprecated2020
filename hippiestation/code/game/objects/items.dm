/obj/item
	var/special_attack = FALSE
	var/special_name = "generic"
	var/special_desc = "not supposed to see this"

/obj/item/proc/do_special_attack(atom/target, mob/living/carbon/user, proximity_flag, cost)
	if(user.getStaminaLoss() >= (100 - cost))
		to_chat(user,"<span class='warning'> You don't have enough stamina to do this!")
		return FALSE
	user.do_attack_animation(target)
	return