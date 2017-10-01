/obj/item/attack(mob/living/M, mob/living/user)
	SendSignal(COMSIG_ITEM_ATTACK, M, user)
	if(flags_1 & NOBLUDGEON_1)
		return
	if(special_attack)//handled by afterattack
		add_fingerprint(user)
		add_logs(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: SPECIAL ATTACK)")
		return
	if(!force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), 1, -1)
	else if(hitsound)
		playsound(loc, hitsound, get_clamped_volume(), 1, -1)

	user.lastattacked = M
	M.lastattacker = user

	user.do_attack_animation(M)

	M.attacked_by(src, user)

	add_logs(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)


/obj/item/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(special_attack && iscarbon(user))
		if(do_special_attack(target, user, proximity_flag))
			var/mob/living/carbon/C = user
			C.adjustStaminaLoss(src.special_cost)
	return