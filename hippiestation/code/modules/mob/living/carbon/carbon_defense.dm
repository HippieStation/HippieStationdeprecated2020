/mob/living/carbon/check_projectile_dismemberment(obj/item/projectile/P, def_zone)
	if(HAS_TRAIT(src, TRAIT_NODISMEMBER))
		return FALSE
	return ..()

/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if(lying || user == src)
		if(surgeries.len)
			if(user.a_intent == "help")
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	..()
