/obj/effect/proc_holder/spell/targeted/stand
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	human_req = FALSE
	clothes_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/stand/proc/Finished()
	charge_counter = 0
	start_recharge()
	remove_ranged_ability()

/obj/effect/proc_holder/spell/targeted/stand/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	var/msg
	if(!can_cast(user))
		msg = "<span class='warning'>You can no longer cast [name]!</span>"
		remove_ranged_ability(msg)
		return
	if(active)
		remove_ranged_ability()
	else
		add_ranged_ability(user, null, TRUE)

	if(action)
		action.UpdateButtonIcon()


/obj/effect/proc_holder/spell/targeted/stand/InterceptClickOn(mob/living/caller, params, atom/t)
	if(!isliving(t))
		to_chat(caller, "<span class='warning'>You may only use this ability on living things!</span>")
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/stand/revert_cast()
	. = ..()
	remove_ranged_ability()

/obj/effect/proc_holder/spell/targeted/stand/start_recharge()
	. = ..()
	if(action)
		action.UpdateButtonIcon()
