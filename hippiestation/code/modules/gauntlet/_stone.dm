/obj/item/infinity_stone
	name = "Generic Stone"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "stone"
	w_class = WEIGHT_CLASS_SMALL
	var/mob/living/current_holder
	var/mob/living/aura_holder
	var/stone_type = ""
	var/list/ability_text = list()
	var/list/spells = list()
	var/list/gauntlet_spells = list()
	var/list/stone_spells = list()
	var/list/spell_types = list()
	var/list/gauntlet_spell_types = list()
	var/list/stone_spell_types = list()
	var/too_many_stones = FALSE
	var/mutable_appearance/aura_overlay

/obj/item/infinity_stone/Initialize()
	. = ..()
	for(var/T in spell_types)
		spells += new T(src)
	for(var/T in gauntlet_spell_types)
		gauntlet_spells += new T(src)
	for(var/T in stone_spell_types)
		stone_spells += new T(src)
//	RegisterSignal(src, COMSIG_ITEM_PICKUP, .proc/UpdateHolder)
//	RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/UpdateHolder)
//	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, .proc/UpdateHolder)
	AddComponent(/datum/component/stationloving, TRUE)
	START_PROCESSING(SSobj, src)
	GLOB.poi_list |= src
	aura_overlay = mutable_appearance('hippiestation/icons/obj/infinity.dmi', "aura", -MUTATIONS_LAYER)
	aura_overlay.color = color

/obj/item/infinity_stone/Destroy()
	GLOB.poi_list -= src
	STOP_PROCESSING(SSobj, src)
	return ..()		

/obj/item/infinity_stone/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='bold notice'>[name]</span>")
	ShowExamine(user)

/obj/item/infinity_stone/forceMove(atom/destination)
	. = ..()
	UpdateHolder()

/obj/item/infinity_stone/proc/ShowExamine(mob/user) // a seperate thing for the gauntlet
	for(var/A in ability_text)
		to_chat(user, "<span class='notice'>[A]</span>")

/obj/item/infinity_stone/proc/GiveAbilities(mob/living/L, gauntlet = FALSE)
	for(var/obj/effect/proc_holder/spell/A in spells)
		L.mob_spell_list += A
		A.action.Grant(L)
	if(gauntlet)
		for(var/obj/effect/proc_holder/spell/A in gauntlet_spells)
			L.mob_spell_list += A
			A.action.Grant(L)
	if(!gauntlet)
		for(var/obj/effect/proc_holder/spell/A in stone_spells)
			L.mob_spell_list += A
			A.action.Grant(L)
			
/obj/item/infinity_stone/proc/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	for(var/obj/effect/proc_holder/spell/A in spells)
		L.mob_spell_list -= A
		A.action.Remove(L)
	if(gauntlet)
		for(var/obj/effect/proc_holder/spell/A in gauntlet_spells)
			L.mob_spell_list -= A
			A.action.Remove(L)

/obj/item/infinity_stone/proc/GiveVisualEffects(mob/living/L)
	L.add_overlay(aura_overlay)

/obj/item/infinity_stone/proc/TakeVisualEffects(mob/living/L)
	L.cut_overlay(aura_overlay)

/obj/item/infinity_stone/proc/GetHolder()
	if(isliving(loc))
		return loc
	return null

/obj/item/infinity_stone/proc/GetAuraHolder()
	return recursive_loc_check(src, /mob/living)

/obj/item/infinity_stone/process()
	UpdateHolder()

/obj/item/infinity_stone/proc/UpdateHolder()
	if(istype(loc, /obj/item/infinity_gauntlet))
		return //gauntlet handles this from now on
	var/mob/living/new_holder = GetHolder()
	var/mob/living/new_aura_holder = GetAuraHolder()
	if (new_holder != current_holder)
		if(isliving(current_holder))
			RemoveAbilities(current_holder)
		if(isliving(new_holder))
			if(loc == new_holder)
				GiveAbilities(new_holder)
			current_holder = new_holder
		else
			current_holder = null
	if (new_aura_holder != aura_holder)
		if(isliving(aura_holder))
			TakeVisualEffects(aura_holder)
			TakeStatusEffect(aura_holder)
		if(isliving(new_aura_holder))
			GiveVisualEffects(new_aura_holder)
			GiveStatusEffect(new_aura_holder)
			aura_holder = new_aura_holder
		else
			aura_holder = null

/obj/item/infinity_stone/proc/GiveStatusEffect(mob/living/target)
	if(istype(loc, /obj/item/infinity_gauntlet))
		return
	var/list/effects = target.has_status_effect_list(/datum/status_effect/infinity_stone)
	var/datum/status_effect/infinity_stone/M
	for(var/datum/status_effect/infinity_stone/MM in effects)
		if(MM.stone == src)
			M = MM
			break
	if(!M)
		M = target.apply_status_effect(/datum/status_effect/infinity_stone, src)

/obj/item/infinity_stone/proc/TakeStatusEffect(mob/living/target)
	var/list/effects = target.has_status_effect_list(/datum/status_effect/infinity_stone)
	var/datum/status_effect/infinity_stone/M
	for(var/datum/status_effect/infinity_stone/MM in effects)
		if(MM.stone == src)
			M = MM
			break
	if(M)
		qdel(M)

/obj/item/infinity_stone/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isliving(user))
		return
	if(istype(target, /obj/item/infinity_gauntlet))
		return
	switch(user.a_intent)
		if(INTENT_DISARM)
			DisarmEvent(target, user, proximity_flag)
		if(INTENT_GRAB)
			GrabEvent(target, user, proximity_flag)
		if(INTENT_HELP)
			HelpEvent(target, user, proximity_flag)
		if(INTENT_HARM)
			HarmEvent(target, user, proximity_flag)

/obj/item/infinity_stone/proc/DisarmEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/HarmEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/GrabEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/HelpEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/infinity_stone/proc/FireProjectile(projectiletype, atom/target, p_damage = null, fire_sound = 'sound/magic/staff_animation.ogg')
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P = new projectiletype(startloc)
	if(p_damage)
		P.damage = p_damage
	P.starting = startloc
	P.firer = isliving(current_holder) ? current_holder : src
	P.yo = target.y - startloc.y
	P.xo = target.x - startloc.x
	P.original = target
	P.preparePixelProjectile(target, src)
	P.fire()
	playsound(src, fire_sound, 50, 1)
	new /obj/effect/temp_visual/dir_setting/firing_effect/magic(get_turf(src))

////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/infinity
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	human_req = FALSE // because a monkey with an infinity stone is funny
	clothes_req = FALSE
	staff_req = FALSE
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/infinity //copypaste from shadowling
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	human_req = FALSE
	clothes_req = FALSE
	staff_req = FALSE
	invocation_type = "none"
	var/obj/item/infinity_stone/stone
	var/mob/living/user
	var/mob/living/target

/obj/effect/proc_holder/spell/targeted/infinity/New(linked_stone)
	. = ..()
	stone = linked_stone

/obj/effect/proc_holder/spell/targeted/infinity/Click()
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


/obj/effect/proc_holder/spell/targeted/infinity/InterceptClickOn(mob/living/caller, params, atom/t)
	if(!isliving(t))
		to_chat(caller, "<span class='warning'>You may only use this ability on living things!</span>")
		revert_cast()
		return FALSE
	user = caller
	target = t
	if(!istype(target))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/infinity/revert_cast()
	. = ..()
	remove_ranged_ability()
	user = null
	target = null

/obj/effect/proc_holder/spell/targeted/infinity/start_recharge()
	. = ..()
	if(action)
		action.UpdateButtonIcon()
