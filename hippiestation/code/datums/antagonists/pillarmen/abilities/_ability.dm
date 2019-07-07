/obj/effect/proc_holder/spell/proc/pillarmen_check(mob/user = usr)
    if (istype(usr, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = user
        return istype(H.dna?.species, /datum/species/pillarmen)
    return FALSE 

/obj/effect/proc_holder/spell/targeted/pillar //Stuns and mutes a human target for 10 seconds
	action_icon = 'hippiestation/icons/mob/actions.dmi'
	action_background_icon = 'hippiestation/icons/mob/actions/backgrounds.dmi'
	action_background_icon_state = "bg_pillar"
	ranged_mousepointer = 'icons/effects/cult_target.dmi'

/obj/effect/proc_holder/spell/targeted/pillar/Click()
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


/obj/effect/proc_holder/spell/targeted/pillar/InterceptClickOn(mob/living/caller, params, atom/t)
	if(!isliving(t))
		to_chat(caller, "<span class='warning'>You may only use this ability on living things!</span>")
		revert_cast()
		return FALSE
	if(!pillarmen_check(caller))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/pillar/revert_cast()
	. = ..()
	remove_ranged_ability()

/obj/effect/proc_holder/spell/targeted/pillar/start_recharge()
	. = ..()
	if(action)
		action.UpdateButtonIcon()
