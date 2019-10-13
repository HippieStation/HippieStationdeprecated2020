#define ALMIGHTY_DAMAGE_MIN		3
#define ALMIGHTY_DAMAGE_MAX		9
#define ALMIGHTY_MIN_COOLDOWN	5 SECONDS

/obj/effect/proc_holder/spell/self/almighty
	name = "The Almighty"
	desc = "Shift the ground below you to bring you into an advantageous position over your target."
	charge_max = 45 SECONDS
	cooldown_min = 45 SECONDS
	clothes_req = FALSE
	staff_req = FALSE
	active = FALSE
	action_icon = 'hippiestation/icons/mob/actions.dmi'
	action_icon_state = "almighty"
	ranged_clickcd_override = CLICK_CD_MELEE
	var/datum/weakref/current_target_weakref
	var/datum/component/lockon_aiming/lockon_component
	var/streak = 0

/obj/effect/proc_holder/spell/self/almighty/proc/reset_streak(reset_charge = FALSE, start_charge = TRUE)
	streak = 0
	if(reset_charge)
		charge_max = initial(charge_max)
	if(start_charge && active)
		charge_counter = 0
		start_recharge()
		action.UpdateButtonIcon()
		remove_ranged_ability()

/obj/effect/proc_holder/spell/self/almighty/remove_ranged_ability(msg)
	. = ..()
	current_target_weakref = null

/obj/effect/proc_holder/spell/self/almighty/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	reset_streak()
	if(!can_cast(user))
		remove_ranged_ability("<span class='warning'>You can no longer cast [name]!</span>")
		return
	QDEL_NULL(lockon_component)
	if(!active)
		lockon_component = user.AddComponent(/datum/component/lockon_aiming, world.view, typecacheof(list(/mob/living)), 1, null, CALLBACK(src, .proc/on_lockon_component, user))
		charge_counter = charge_max

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
		charge_counter = 0
		start_recharge()
		action.UpdateButtonIcon()
		QDEL_NULL(lockon_component)
		remove_ranged_ability()
		reset_streak()
		return
	if(isturf(A) && current_target_weakref)
		var/mob/living/L = current_target_weakref.resolve()
		QDEL_NULL(lockon_component)
		if(!QDELETED(L) && istype(L) && isturf(L.loc))
			advantage(caller, L)
			return TRUE
		charge_counter = 0
		start_recharge()
		action.UpdateButtonIcon()
		remove_ranged_ability()
		reset_streak()
	return FALSE

/obj/effect/proc_holder/spell/self/almighty/proc/attack(mob/living/user, mob/living/target)
	if(prob(35))
		user.do_attack_animation(target, ATTACK_EFFECT_KICK)
		user.visible_message("<span class='danger'>[user] swiftly kicks [target]!</span>")
	else
		user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)
		user.visible_message("<span class='danger'>[user] punches [target]!</span>")
	user.apply_damage(CLAMP(((streak + 6) * 0.45), ALMIGHTY_DAMAGE_MIN, ALMIGHTY_DAMAGE_MAX), BRUTE, target.get_bodypart(ran_zone(user.zone_selected)), FALSE)
	streak++
	var/ic = initial(charge_max)
	charge_max = CLAMP(ic / (streak * 0.25), ALMIGHTY_MIN_COOLDOWN, ic)
	addtimer(CALLBACK(src, .proc/reset_streak, FALSE, FALSE), 3 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

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
					best_dist = our_dist
	if(best_position)
		user.forceMove(best_position)
		playsound(user, 'sound/magic/wand_teleport.ogg', 75, TRUE)
		user.face_atom(target)
		attack(user, target)

#undef ALMIGHTY_MIN_COOLDOWN
#undef ALMIGHTY_DAMAGE_MAX
#undef ALMIGHTY_DAMAGE_MIN
