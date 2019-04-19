/obj/effect/proc_holder/spell/self/bfs
	name = "Interdimensional Sword"
	desc = "Summons a humungous, flaming sword from another dimension."
	charge_max = 200
	cooldown_min = 95
	clothes_req = FALSE
	human_req = TRUE
	sound = 'sound/magic/clockwork/invoke_general.ogg'
	var/length = 9

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
	chugga_chugga(get_turf(user), user.dir, 1, FALSE)

/obj/effect/proc_holder/spell/self/bfs/proc/damage_turf(turf/T)
	for(var/mob/living/L in T)
		L.visible_message("<span class='danger'>[L] is hit by the Interdimensional Sword!</span>")
		L.adjustFireLoss(8.75)
		L.adjustBruteLoss(8.75)
		L.fire_stacks += 3
		L.IgniteMob()
		if(prob(35))
			var/list/parts = target_bodyparts(L)
			if(LAZYLEN(parts))
				var/obj/item/bodypart/BP = pick(parts)
				BP.dismember()
				L.visible_message("<span class='danger'>[L]'s [BP] is turned to ashes by the Interdimensional Sword!</span>'", "<span class='userdanger'>Your [BP] is turned to ashes by the Interdimensional Sword!</span>")
				qdel(BP)
				new /obj/effect/decal/cleanable/ash(T)
	for(var/obj/O in T)
		if(!istype(O, /obj/effect))
			O.visible_message("<span class='danger'>[O] is annihilated by the Interdimensional Sword!</span>")
			O.take_damage(INFINITY) //absolutely destroy any objects
	if(isclosedturf(T))
		T.visible_message("<span class='danger'>[T] is torn away by the Interdimensional Sword!</span>")
		T.ScrapeAway() //tear down to baseturf

/obj/effect/proc_holder/spell/self/bfs/proc/chugga_chugga(turf/T, direction, chugga_amount, reverse)
	var/turf/tip = multistep(T, direction, chugga_amount)
	var/turf/fl_tip = multistep(T, direction, length)
	var/turf/hilt = multistep(fl_tip, turn(direction, 180), chugga_amount)
	var/turf/i_hilt = multistep(fl_tip, turn(direction, 180), length-1)
	QDEL_IN(new /obj/effect/bfs/portal(i_hilt, turn(direction, 180)), 1)
	QDEL_IN(new /obj/effect/bfs/portal(fl_tip, direction), 1)
	if(!reverse)
		damage_turf(tip)
		QDEL_IN(new /obj/effect/bfs/tip(tip, direction), 1)
		if (chugga_amount > 0)
			for(var/turf/A in getline(get_step(T, direction), tip)-tip)
				QDEL_IN(new /obj/effect/bfs/blade(A, direction), 1)
		if(chugga_amount < length)
			addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount+1, FALSE), 1)
		else
			addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount, TRUE), 1)
			explosion(tip, 0, 0, 3, 4, flame_range = 3)
	else
		for(var/turf/A in getline(hilt, fl_tip)-hilt)
			QDEL_IN(new /obj/effect/bfs/blade(A, direction), 1)
		QDEL_IN(new /obj/effect/bfs/hilt(hilt, direction), 1)
		if(chugga_amount > 0)
			addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount-1, TRUE), 1)

/obj/effect/proc_holder/spell/self/bfs/proc/multistep(ref, dir, amt)
	var/turf/T = get_turf(ref)
	for(var/j=0; j<amt ;j++)
		T = get_step(T, dir)
	return T


/obj/effect/bfs
	icon = 'hippiestation/icons/effects/bfs.dmi'
	density = TRUE // it's a bigass sword lol

/obj/effect/bfs/Initialize(mapload, direction)
	. = ..()
	setDir(direction)

/obj/effect/bfs/tip
	icon_state = "tip"

/obj/effect/bfs/blade
	icon_state = "blade"

/obj/effect/bfs/hilt
	icon_state = "hilt"

/obj/effect/bfs/portal
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	layer = ABOVE_OBJ_LAYER
