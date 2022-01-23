GLOBAL_LIST_INIT(reflect_blacklist, typecacheof(list(/obj/structure, /obj/machinery/button, /obj/item/cigbutt, /obj/effect, /obj/machinery/atmospherics, /obj/machinery/disposal, /obj/machinery/camera, /obj/machinery/door, /obj/structure/closet, /obj/structure/transit_tube)))

/mob/living/simple_animal/hostile/guardian/reflective
	melee_damage_lower = 35
	melee_damage_upper = 35
	range = 5
	playstyle_string = "<span class='holoparasite'>As a <b>reflective</b> type, you are only capable of existing inside of objects which you reflect to. You are invisible to all, unless they examine your host object.</span>"
	magic_fluff_string = "<span class='holoparasite'>..And draw the Chameleon, capable of hiding in plain sight.</span>"
	tech_fluff_string = "<span class='holoparasite'>Boot sequence complete. Reflective combat modules active. Holoparasite swarm online.</span>"
	carp_fluff_string = "<span class='holoparasite'>CARP CARP CARP! Caught one, but I can't see it, it's reflective!</span>"

	var/lastangle = 0
	var/aiming_lastangle = 0
	var/obj/host
	var/list/examined_host

/mob/living/simple_animal/hostile/guardian/reflective/Initialize(mapload, theme)
	. = ..()
	UpdateViewers()
	AddSpell(new /obj/effect/proc_holder/spell/targeted/reflect)

/mob/living/simple_animal/hostile/guardian/reflective/Life()
	. = ..()
	UpdateViewers()

/mob/living/simple_animal/hostile/guardian/reflective/CanPass(atom/movable/mover, turf/target)
	if(!isliving(mover)) // non-living things pass through it
		return TRUE
	return !can_see(mover, FALSE)

/mob/living/simple_animal/hostile/guardian/reflective/start_pulling(atom/movable/AM, state, force = pull_force, supress_message = FALSE)
	if(AM == host)
		return FALSE
	return ..()

// don't show an obvious message when the summoner is likely off screen
/mob/living/simple_animal/hostile/guardian/reflective/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = amount
	if(summoner)
		if(loc == summoner || loc == host)
			return FALSE
		summoner.adjustBruteLoss(amount)
		if(amount > 0)
			to_chat(summoner, "<span class='danger'><B>Your [name] is under attack! You take damage!</span></B>")
			if(summoner.stat == UNCONSCIOUS)
				to_chat(summoner, "<span class='danger'><B>Your body can't take the strain of sustaining [src] in this condition, it begins to fall apart!</span></B>")
				summoner.adjustCloneLoss(amount * 0.5) //dying hosts take 50% bonus damage as cloneloss

/mob/living/simple_animal/hostile/guardian/reflective/AttackingTarget()
	if(!host || !istype(host))
		return // can't attack anything if you're not reflecting
	if(!isliving(target))
		return
	if(target == summoner)
		return
	var/mob/living/L = target
	var/bodypart = pick("shoulder", "side")
	if(can_see(target, FALSE))
		to_chat(target, "<span class='danger'>[src] stabs you in the [bodypart]!")
	else
		to_chat(target, "<span class='danger'>Out of nothingness, something stabs you in the [bodypart]!")
	for(var/mob/M in viewers(world.view, src) - target)
		if(can_see(M, FALSE))
			to_chat(M, "<span class='danger'>[src] stabs [target] in the [bodypart]!")
		else
			to_chat(M, "<span class='danger'>Out of nothingness, something stabs [target] in the [bodypart]!")
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.bleed_rate = min(H.bleed_rate + 9.5, 9.5)
		H.blood_volume -= 20
		H.adjustBruteLoss(5)
		// spray blood
		var/obj/effect/decal/cleanable/blood/hitsplatter/B = new(H.loc)
		B.add_blood_DNA(H.return_blood_DNA())
		B.blood_source = H
		playsound(H, pick('hippiestation/sound/effects/splash.ogg'), 40, TRUE, -1)
		var/dist = rand(1,3)
		var/turf/targ = get_ranged_target_turf(H, get_dir(src, H), dist)
		B.GoTo(targ, dist)
	else
		L.adjustBruteLoss(40)
	changeNext_move(35) // kinda slow

/mob/living/simple_animal/hostile/guardian/reflective/snapback()
	if(!host || !istype(host) || !isturf(host.loc))
		forceMove(summoner)
	if(host)
		if(get_dist(get_turf(host),get_turf(src)) <= range)
			return
		else
			to_chat(src, "<span class='holoparasite'>You moved out of range, and were pulled back! You can only move [range] meters from your host object!</span>")
			forceMove(host.loc)

/mob/living/simple_animal/hostile/guardian/reflective/Manifest(forced)
	if(loc == summoner)
		to_chat(src, "<span class='warning'>You must reflect in order to manifest!</span>")
		return FALSE
	if(!host || !istype(host) || !isturf(host.loc))
		return FALSE
	if(loc == host)
		forceMove(host.loc)
		LAZYCLEARLIST(examined_host)
		cooldown = world.time + 10
		reset_perspective()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/guardian/reflective/Recall(forced)
	if(cooldown > world.time && !forced)
		return FALSE
	if(host && istype(host) && loc != host && loc != summoner)
		forceMove(host)
		cooldown = world.time + 10
		return TRUE
	if(loc == host || !host || !istype(host))
		Goodbye()
		forceMove(summoner)
		cooldown = world.time + 10
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/guardian/reflective/proc/UpdateViewers()
	remove_alt_appearance("hanged_man")
	var/image/I = image(icon = 'icons/effects/blood.dmi', icon_state = null, loc = src)
	I.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/hanged_man, "hanged_man", I, NONE, src)
	remove_from_all_data_huds() // won't show up on any sort of hud

/mob/living/simple_animal/hostile/guardian/reflective/proc/Goodbye()
	if(host)
		var/datum/component/AM = host.GetComponent(/datum/component/hanged_man)
		if(AM && istype(AM))
			AM.RemoveComponent()
	LAZYCLEARLIST(examined_host)
	host = null
	forceMove(summoner)

/mob/living/simple_animal/hostile/guardian/reflective/proc/can_see(mob/M, cone = TRUE)
	if(M == src || M == summoner)
		return TRUE
	if(!LAZYLEN(examined_host))
		return FALSE
	if(!(M in examined_host))
		return FALSE
	if(!cone || host.InCone(M, M.dir))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/guardian/reflective/Move()
	. = ..()
	UpdateViewers()

///////////////////////
// THE REFLECT SPELL //
///////////////////////

/obj/effect/proc_holder/spell/targeted/reflect //copypaste from shadowling
	name = "Reflect"
	desc = "Reflect onto a new object!"
	charge_max = 15 SECONDS
	action_icon = 'hippiestation/icons/mob/actions.dmi'
	action_icon_state = "reflect"
	action_background_icon_state = "bg_tech_blue"
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	human_req = FALSE
	clothes_req = FALSE
	staff_req = FALSE
	antimagic_allowed = TRUE
	invocation_type = "none"


/obj/effect/proc_holder/spell/targeted/reflect/proc/Finished()
	charge_counter = 0
	start_recharge()
	remove_ranged_ability()
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/reflect/Click()
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


/obj/effect/proc_holder/spell/targeted/reflect/InterceptClickOn(mob/living/caller, params, atom/t)
	if(!isobj(t))
		to_chat(caller, "<span class='warning'>You may only reflect into objects!</span>")
		return FALSE
	if(is_type_in_typecache(t, GLOB.reflect_blacklist) || t.GetComponent(/datum/component/storage))
		to_chat(caller, "<span class='warning'>You can't reflect into [t]!</span>")
		return FALSE
	var/mob/living/simple_animal/hostile/guardian/reflective/G = caller
	if(!istype(G) || !G)
		revert_cast()
		return FALSE
	G.loc.Beam(t, "light_beam", 'hippiestation/icons/effects/beam.dmi', 2)
	G.Goodbye()
	to_chat(G, "<span class='notice'>You reflect onto [t].</span>")
	G.host = t
	t.AddComponent(/datum/component/hanged_man, G)
	G.forceMove(t)
	Finished()
	return TRUE

////////////////////
// ALT APPEARANCE //
////////////////////
/datum/atom_hud/alternate_appearance/basic/hanged_man
	var/mob/living/simple_animal/hostile/guardian/reflective/guardian

/datum/atom_hud/alternate_appearance/basic/hanged_man/New(key, image/I, options, mob/living/simple_animal/hostile/guardian/reflective/guard)
	..()
	guardian = guard
	for(var/mob/M in GLOB.mob_list)
		if(mobShouldSee(M))
			add_hud_to(M)
			M.reload_huds()

/datum/atom_hud/alternate_appearance/basic/hanged_man/mobShouldSee(mob/M)
	if(isobserver(M) || guardian.can_see(M))
		return FALSE // they see the actual sprite
	return TRUE

///////////////
// COMPONENT //
///////////////
/datum/component/hanged_man
	var/mob/living/simple_animal/hostile/guardian/reflective/guardian
	var/obj/effect/reflective_light/reflection

/datum/component/hanged_man/Initialize(mob/living/simple_animal/hostile/guardian/reflective/G)
	guardian = G
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/examine)
	RegisterSignal(parent, 	COMSIG_PARENT_PREQDELETED, .proc/oh_god_lets_get_out)
	reflection = new(parent)

/datum/component/hanged_man/UnregisterFromParent()
	. = ..()
	qdel(reflection)

/datum/component/hanged_man/proc/examine(datum/source, mob/M)
	if(guardian.host == parent) //sanity check
		if(!(M in guardian.examined_host))
			LAZYADD(guardian.examined_host, M)
			guardian.UpdateViewers()
		to_chat(M, "<span class='holoparasite'>You see something within \the [parent].</span>")

/datum/component/hanged_man/proc/oh_god_lets_get_out()
	to_chat(guardian, "<span class='danger'>Your object was destroyed, so you returned to your summoner!</span>")
	guardian.Goodbye()

/obj/effect/reflective_light
	light_color = "#BFFF00"
	light_range = 5

///////////
// STUFF //
///////////
/atom/proc/InCone(atom/center, dir = NORTH)
	if(!get_dist(center, src) || src == center)
		return FALSE

	var/d = get_dir(center, src)
	var/dx = abs(x - center.x)
	var/dy = abs(y - center.y)

	if(!d || d == dir)
		return TRUE
	else if(dir & (dir-1))
		return (d & ~dir) ? FALSE : TRUE
	else if(!(d & dir))
		return FALSE
	else if(dx == dy)
		return TRUE
	else if(dy > dx)
		return (dir & (NORTH|SOUTH)) ? TRUE : FALSE

	return (dir & (EAST|WEST)) ? TRUE : FALSE
