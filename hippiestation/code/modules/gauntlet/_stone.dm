//Originally coded for HippieStation by Steamp0rt, shared under the AGPL license.

/obj/item/badmin_stone
	name = "Generic Stone"
	icon = 'hippiestation/icons/obj/infinity.dmi'
	icon_state = "stone"
	w_class = WEIGHT_CLASS_SMALL
	var/mob/living/current_holder
	var/mob/living/aura_holder
	var/mob/living/last_holder
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

/obj/item/badmin_stone/Initialize()
	. = ..()
	for(var/T in spell_types)
		spells += new T(src)
	for(var/T in gauntlet_spell_types)
		gauntlet_spells += new T(src)
	for(var/T in stone_spell_types)
		stone_spells += new T(src)
//	RegisterSignal(src, COMSIG_ITEM_DROPPED, .proc/UpdateHolder)
//	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, .proc/UpdateHolder)
	AddComponent(/datum/component/stationloving, TRUE)
	START_PROCESSING(SSobj, src)
	GLOB.poi_list |= src
	aura_overlay = mutable_appearance('hippiestation/icons/obj/infinity.dmi', "aura", -MUTATIONS_LAYER)
	aura_overlay.color = color
	notify_ghosts("\The [src] has been formed!",
		enter_link="<a href=?src=[REF(src)];orbit=1>(Click to orbit)</a>",
		source = src, action=NOTIFY_ORBIT, ignore_key = POLL_IGNORE_SPECTRAL_BLADE)

/obj/item/badmin_stone/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/item/badmin_stone/Destroy()
	GLOB.poi_list -= src
	STOP_PROCESSING(SSobj, src)
	return ..()		

/obj/item/badmin_stone/examine(mob/user)
	. = ..()
	. += "<span class='bold notice'>[name]</span>"
	for(var/A in ability_text)
		. += "<span class='notice'>[A]</span>"

/obj/item/badmin_stone/forceMove(atom/destination)
	. = ..()
	UpdateHolder()

/obj/item/badmin_stone/ex_act(severity, target)
	return

/obj/item/badmin_stone/pickup(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna && H.dna.check_mutation(CLUWNEMUT))
			to_chat(H, "<span class='danger'>\The [src] pulses in your hands, sending a spasm of pain and forcing you to drop it!</span>")
			addtimer(CALLBACK(src, .proc/NoPickingMeUp, H), 5)

/obj/item/badmin_stone/proc/NoPickingMeUp(mob/user)
	user.dropItemToGround(src, TRUE)
	forceMove(get_turf(user))

/obj/item/badmin_stone/proc/GiveAbilities(mob/living/L, gauntlet = FALSE)
	for(var/obj/effect/proc_holder/spell/A in spells)
		L.mob_spell_list += A
		A.action.Grant(L)
	if(gauntlet)
		for(var/obj/effect/proc_holder/spell/A in gauntlet_spells)
			L.mob_spell_list += A
			A.action.Grant(L)
	else
		for(var/obj/effect/proc_holder/spell/A in stone_spells)
			L.mob_spell_list += A
			A.action.Grant(L)
			
/obj/item/badmin_stone/proc/RemoveAbilities(mob/living/L, gauntlet = FALSE)
	for(var/obj/effect/proc_holder/spell/A in spells)
		L.mob_spell_list -= A
		A.action.Remove(L)
	for(var/obj/effect/proc_holder/spell/A in stone_spells)
		L.mob_spell_list -= A
		A.action.Remove(L)
	for(var/obj/effect/proc_holder/spell/A in gauntlet_spells)
		L.mob_spell_list -= A
		A.action.Remove(L)

/obj/item/badmin_stone/proc/GiveVisualEffects(mob/living/L)
	L.add_overlay(aura_overlay)

/obj/item/badmin_stone/proc/TakeVisualEffects(mob/living/L)
	L.cut_overlay(aura_overlay)

/obj/item/badmin_stone/proc/GetHolder()
	if(isliving(loc))
		return loc
	return null

/obj/item/badmin_stone/proc/GetAuraHolder()
	return recursive_loc_check(src, /mob/living)

/obj/item/badmin_stone/process()
	UpdateHolder()

/obj/item/badmin_stone/proc/UpdateHolder()
	if(istype(loc, /obj/item/badmin_gauntlet))
		return //gauntlet handles this from now on
	var/mob/living/new_holder = GetHolder()
	var/mob/living/new_aura_holder = GetAuraHolder()
	if(ishuman(new_aura_holder))
		var/mob/living/carbon/human/H = new_aura_holder
		if(H.dna && H.dna.check_mutation(CLUWNEMUT))
			NoPickingMeUp(H)
			return
	if (new_holder != current_holder)
		if(isliving(current_holder))
			RemoveAbilities(current_holder)
		if(isliving(new_holder))
			if(loc == new_holder)
				GiveAbilities(new_holder)
			current_holder = new_holder
		else
			current_holder = null
	if (new_aura_holder != last_holder && isliving(new_aura_holder)) 
		log_game("[src] has a new holder: [ADMIN_LOOKUPFLW(new_aura_holder)]!")
		message_admins("[src] has a new holder: [key_name(new_aura_holder)]!")
	if (new_aura_holder != aura_holder)
		if(isliving(aura_holder))
			TakeVisualEffects(aura_holder)
			TakeStatusEffect(aura_holder)
		if(isliving(new_aura_holder))
			log_game("[src] has a new holder: [ADMIN_LOOKUPFLW(new_aura_holder)]!")
			message_admins("[src] has a new holder: [key_name(new_aura_holder)]!")
			GiveVisualEffects(new_aura_holder)
			GiveStatusEffect(new_aura_holder)
			aura_holder = new_aura_holder
			last_holder = new_aura_holder
		else
			aura_holder = null

/obj/item/badmin_stone/proc/GiveStatusEffect(mob/living/target)
	if(istype(loc, /obj/item/badmin_gauntlet))
		return
	var/list/effects = target.has_status_effect_list(/datum/status_effect/badmin_stone)
	var/datum/status_effect/badmin_stone/M
	for(var/datum/status_effect/badmin_stone/MM in effects)
		if(MM.stone == src)
			M = MM
			break
	if(!M)
		M = target.apply_status_effect(/datum/status_effect/badmin_stone, src)

/obj/item/badmin_stone/proc/TakeStatusEffect(mob/living/target)
	var/list/effects = target.has_status_effect_list(/datum/status_effect/badmin_stone)
	var/datum/status_effect/badmin_stone/M
	for(var/datum/status_effect/badmin_stone/MM in effects)
		if(MM.stone == src)
			M = MM
			break
	if(M)
		qdel(M)

/obj/item/badmin_stone/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isliving(user))
		return
	if(istype(target, /obj/item/badmin_gauntlet))
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

/obj/item/badmin_stone/proc/DisarmEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/badmin_stone/proc/HarmEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/badmin_stone/proc/GrabEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/badmin_stone/proc/HelpEvent(atom/target, mob/living/user, proximity_flag)

/obj/item/badmin_stone/proc/FireProjectile(projectiletype, atom/target, p_damage = null, fire_sound = 'sound/magic/staff_animation.ogg')
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
	antimagic_allowed = TRUE
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/infinity //copypaste from shadowling
	action_icon = 'hippiestation/icons/obj/infinity.dmi'
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	human_req = FALSE
	clothes_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	invocation_type = "none"
	var/obj/item/badmin_stone/stone
	var/mob/living/user
	var/mob/living/target

/obj/effect/proc_holder/spell/targeted/infinity/New(linked_stone)
	. = ..()
	stone = linked_stone

/obj/effect/proc_holder/spell/targeted/infinity/proc/Finished()
	charge_counter = 0
	start_recharge()
	remove_ranged_ability()

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
