/obj/effect/proc_holder/spell/self/bfs
	name = "Interdimensional Sword"
	desc = "Summons a humungous, flaming sword from another dimension."
	charge_max = 250
	cooldown_min = 105
	clothes_req = FALSE
	human_req = TRUE
	sound = 'sound/magic/clockwork/invoke_general.ogg'
	var/length = 11

/obj/effect/proc_holder/spell/self/bfs/proc/target_bodyparts(atom/the_target) //stolen from gorillacode
	var/list/parts = list()
	if(iscarbon(the_target))
		var/mob/living/carbon/C = the_target
		for(var/X in C.bodyparts)
			var/obj/item/bodypart/BP = X
			if(BP.body_part != HEAD && BP.body_part != CHEST)
				if(BP.dismemberable)
					parts += BP
	return parts

/obj/effect/proc_holder/spell/self/bfs/cast(mob/user = usr)
	user.visible_message("<span class='danger bold'>[user] summons the Interdimensional Sword!</span>")
	var/turf/fl_tip = multistep(get_turf(user), user.dir, length)
	var/turf/i_hilt = multistep(fl_tip, turn(user.dir, 180), length-1)
	var/start_portal = new /obj/effect/bfs_portal(i_hilt, turn(user.dir, 180))
	var/end_portal = new /obj/effect/bfs_portal(fl_tip, user.dir)
	flick("portal_open", start_portal)
	flick("portal_open", end_portal)
	QDEL_IN(start_portal, length*2)
	QDEL_IN(end_portal, length*2)
	chugga_chugga(get_turf(user), user.dir, 1, FALSE)

/obj/effect/proc_holder/spell/self/bfs/proc/damage_turf(turf/T)
	for(var/mob/living/L in T)
		if(L.anti_magic_check())
			L.visible_message("<span class='danger'>The Interdimensional Sword phases through [L]!</span>")
			continue
		L.visible_message("<span class='danger'>[L] is hit by the Interdimensional Sword!</span>", "<span class='userdanger'>The Interdimensional Sword slams into you!</span>")
		L.adjustFireLoss(12.5)
		L.adjustBruteLoss(12.5)
		if(prob(35))
			var/list/parts = target_bodyparts(L)
			if(LAZYLEN(parts))
				var/obj/item/bodypart/BP = pick(parts)
				BP.drop_limb()
				L.visible_message("<span class='danger'>[L]'s [BP] is turned to ashes by the Interdimensional Sword!</span>", "<span class='userdanger'>Your [BP] is turned to ashes by the Interdimensional Sword!</span>")
				qdel(BP)
				new /obj/effect/decal/cleanable/ash(T)
			else
				lol(L)
		else
			lol(L)
	for(var/obj/O in T)
		if(!istype(O, /obj/effect))
			O.visible_message("<span class='danger'>[O] is annihilated by the Interdimensional Sword!</span>")
			O.take_damage(INFINITY) //absolutely destroy any objects
	if(isclosedturf(T))
		T.visible_message("<span class='danger'>[T] is torn away by the Interdimensional Sword!</span>")
		T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR) //tear down to baseturf
		
/obj/effect/proc_holder/spell/self/bfs/proc/lol(mob/living/L)
	L.fire_stacks += 3
	L.IgniteMob()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.bleed_rate = max(H.bleed_rate + 9, 6)
		H.blood_volume -= 10
		var/obj/effect/decal/cleanable/blood/hitsplatter/B = new(H.loc) // you just got impaled by a big-ass sword
		B.add_blood_DNA(H.return_blood_DNA())
		B.blood_source = H
		playsound(H, pick('hippiestation/sound/effects/splash.ogg'), 40, TRUE, -1)
		var/dist = rand(1,3)
		var/turf/targ = get_ranged_target_turf(H, pick(GLOB.alldirs), dist)
		B.GoTo(targ, dist)

/obj/effect/proc_holder/spell/self/bfs/proc/chugga_chugga(turf/T, direction, chugga_amount, reverse)
	var/turf/tip = multistep(T, direction, chugga_amount)
	var/turf/fl_tip = multistep(T, direction, length)
	var/turf/hilt = multistep(fl_tip, turn(direction, 180), chugga_amount)
	if(!reverse)
		INVOKE_ASYNC(src, .proc/damage_turf, tip)
		new /obj/effect/temp_visual/bfs/tip(tip, direction)
		if (chugga_amount > 0)
			for(var/turf/A in getline(get_step(T, direction), tip)-tip)
				new /obj/effect/temp_visual/bfs/blade(A, direction)
		if(chugga_amount < length)
			addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount+1, FALSE), 1)
		else
			addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount, TRUE), 1)
	else
		for(var/turf/A in getline(hilt, fl_tip)-hilt)
			new /obj/effect/temp_visual/bfs/blade(A, direction)
		new /obj/effect/temp_visual/bfs/hilt(hilt, direction)
		if(chugga_amount > 0)
			addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount-1, TRUE), 1)

/obj/effect/proc_holder/spell/self/bfs/proc/multistep(ref, dir, amt)
	var/turf/T = get_turf(ref)
	for(var/j=0; j<amt ;j++)
		T = get_step(T, dir)
	return T


/obj/effect/temp_visual/bfs
	icon = 'hippiestation/icons/effects/bfs.dmi'
	randomdir = FALSE
	duration = 1
	density = TRUE // it's a bigass sword lol
	layer = LYING_MOB_LAYER + 0.1

/obj/effect/temp_visual/bfs/Initialize(mapload, direction)
	. = ..()
	setDir(direction)

/obj/effect/temp_visual/bfs/tip
	icon_state = "tip"

/obj/effect/temp_visual/bfs/blade
	icon_state = "blade"

/obj/effect/temp_visual/bfs/hilt
	icon_state = "hilt"

/obj/effect/bfs_portal
	icon = 'hippiestation/icons/effects/bfs.dmi'
	icon_state = "portal"
	layer = LYING_MOB_LAYER + 0.15
	density = TRUE // it's a bigass sword lol

/obj/effect/bfs_portal/Initialize(mapload, direction)
	. = ..()
	setDir(direction)
