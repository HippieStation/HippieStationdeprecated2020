/datum/guardian_ability/major/special/dejavu
	name = "Deja Vu"
	desc = "The power to reset to zero..."
	cost = 6
	spell_type = /obj/effect/proc_holder/spell/self/zero
	arrow_weight = 0.9

/obj/effect/proc_holder/spell/self/zero
	name = "Deja Vu"
	desc = "Reset everything to ZERO after 10 seconds."
	clothes_req = FALSE
	staff_req = FALSE
	human_req = FALSE
	charge_max = 90 SECONDS
	action_icon_state = "time"

/obj/effect/proc_holder/spell/self/zero/cast(list/targets, mob/user)
	if(!isturf(user.loc) && !isguardian(user))
		revert_cast()
		return
	for(var/mob/living/L in range(7, user))
		L.AddComponent(/datum/component/dejavu/stand)
