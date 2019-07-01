///////////////////
// WRAPPIT STUFF //
///////////////////
/obj/effect/proc_holder/spell/proc/pillarmen_check(mob/user = usr)
    if (istype(usr, /mob/living/carbon/human))
        var/mob/living/carbon/human/H = user
        return istype(H.dna?.species, /datum/species/pillarmen)
    return FALSE 

/obj/effect/proc_holder/spell/targeted/pillar //Stuns and mutes a human target for 10 seconds
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

  ///////////////////////
 // THE ACTUAL SPELLS //
///////////////////////

/obj/effect/proc_holder/spell/self/pillar_hatch
	name = "Emerge"
	desc = "Emerge from your shell, and become a full Pillar Man"
	charge_max = 0
	clothes_req = FALSE
	var/emerging = FALSE

/obj/effect/proc_holder/spell/self/pillar_hatch/cast(list/targets, mob/user)
	if(emerging || !user || user.stat || !is_station_level(user.z) || !ishuman(user))
		revert_cast()
		return
	var/mob/living/carbon/human/H = user
	var/thingy = alert(H,"Are you sure you want to emerge? You cannot undo this!",,"Yes","No")
	switch(thingy)
		if("No")
			revert_cast()
		if("Yes")
			emerging = TRUE
			INVOKE_ASYNC(src, .proc/emerge, H)

/obj/effect/proc_holder/spell/self/pillar_hatch/proc/emerge(mob/living/carbon/human/H)
	H.status_flags |= GODMODE
	H.SetStun(INFINITY)
	var/list/walls = list()
	for(var/turf/T in orange(1, get_turf(H)))
		walls += T.PlaceOnTop(/turf/closed/wall/mineral/sandstone)
	notify_ghosts("[H] has begun to emerge as a Pillar Man at [get_area(H)]", source = H, action = NOTIFY_ORBIT)
	H.visible_message("<span class='notice bold'>[H] closes their eyes and begins to concentrate...</span>")
	sleep(100)
	H.visible_message("<span class='notice bold'>[H]'s muscles begin to bulge out, as their skin tans...</span>")
	H.unequip_everything()
	H.set_species(/datum/species/pillarmen)
	H.faction |= "pillarmen"
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.SetStun(0)
	H.status_flags &= ~GODMODE
	sleep(100)
	H.visible_message("<span class='notice bold'>[H] smiles as they begin to punch their way out of their cocoon...</span>")
	for(var/i = 1 to 10)
		playsound(get_turf(H), 'sound/effects/bang.ogg', 100, TRUE)
		sleep(10)
	H.visible_message("<span class='danger bold'>[H] bursts out of the sandstone cocoon, full of power!</span>")
	for(var/turf/closed/wall/mineral/sandstone/SSW in walls)
		SSW.ScrapeAway(1)
	notify_ghosts("[H] has emerged as a Pillar Man at [get_area(H)]", source = H, action = NOTIFY_ORBIT)
	playsound(get_turf(H), 'sound/hallucinations/veryfar_noise.ogg', 100, TRUE)
	H.mind.RemoveSpell(src)
