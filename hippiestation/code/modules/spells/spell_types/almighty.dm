/obj/effect/proc_holder/spell/self/almighty
	name = "The Almighty"
	desc = "Shift the ground below you to bring you into an advantageous position over your target."
	charge_max = 0
	clothes_req = FALSE
	staff_req = FALSE
	active = FALSE
	action_icon = 'hippiestation/icons/mob/actions.dmi'
	action_icon_state = "almighty"
	ranged_clickcd_override = 6 // halfway between CLICK_CD_RANGE and CLICK_CD_MELEE
	var/datum/weakref/current_target_weakref
	var/datum/component/lockon_aiming/lockon_component

/obj/effect/proc_holder/spell/self/almighty/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		remove_ranged_ability("<span class='warning'>You can no longer cast [name]!</span>")
		return
	QDEL_NULL(lockon_component)
	if(active)
		remove_ranged_ability()
	else
		lockon_component = user.AddComponent(/datum/component/lockon_aiming, world.view, typecacheof(list(/mob/living)), 1, null, CALLBACK(src, .proc/on_lockon_component, user))

/obj/effect/proc_holder/spell/self/almighty/proc/on_lockon_component(mob/living/user, list/locked_weakrefs)
	if(!length(locked_weakrefs))
		current_target_weakref = null
		return
	current_target_weakref = locked_weakrefs[1]
	var/atom/A = current_target_weakref.resolve()
	if(A)
		var/mob/M = lockon_component.parent
		M.face_atom(A)
		add_ranged_ability(user, null, TRUE)

/obj/effect/proc_holder/spell/self/almighty/InterceptClickOn(mob/living/caller, params, atom/A)
	if(..())
		return FALSE
	if(caller.incapacitated())
		QDEL_NULL(lockon_component)
		remove_ranged_ability()
		return
	if(isturf(A) && current_target_weakref)
		var/mob/living/L = current_target_weakref.resolve()
		QDEL_NULL(lockon_component)
		if(!QDELETED(L) && istype(L) && isturf(L.loc))
			advantage(caller, L)
			return TRUE
		remove_ranged_ability()
	return FALSE

/obj/effect/proc_holder/spell/self/almighty/proc/attack(mob/living/user, mob/living/target)
	var/obj/item/W = user.get_active_held_item()
	if(W)
		W.melee_attack_chain(user, target)
	else
		user.changeNext_move(CLICK_CD_MELEE)
		user.UnarmedAttack(target)

/obj/effect/proc_holder/spell/self/almighty/proc/advantage(mob/living/user, mob/living/target)
	if(target.client)
		var/datum/position/P = mouse_absolute_datum_map_position_from_client(target.client)
		if(P && istype(P))
			var/turf/T = P.return_turf()
			if(T && istype(T))
				true_advantage(user, target, T)
				return
	user.forceMove(get_step(target, pick(GLOB.alldirs)))
	playsound(user, 'sound/magic/wand_teleport.ogg', 75, TRUE)
	user.face_atom(target)
	attack(user, target)

/obj/effect/proc_holder/spell/self/almighty/proc/true_advantage(mob/living/user, mob/living/target, turf/mouse_pos)
	var/turf/best_position
	var/best_dist
	for(var/dir in GLOB.alldirs)
		var/turf/T = get_step(target, dir)
		if(isopenturf(T))
			var/our_dist = get_dist(T, mouse_pos)
			if(!best_position)
				best_position = T
				best_dist = our_dist
			else
				if(our_dist > best_dist)
					best_position = T
	if(best_position)
		user.forceMove(best_position)
		playsound(user, 'sound/magic/wand_teleport.ogg', 75, TRUE)
		user.face_atom(target)
		attack(user, target)
