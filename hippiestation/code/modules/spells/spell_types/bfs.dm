/obj/effect/proc_holder/spell/self/bigass_sword
	name = "Big Flaming Sword"
	desc = "Summons a humungous, flaming sword."
	charge_max = 250
	cooldown_min = 100
	clothes_req = FALSE
	human_req = TRUE
	sound = 'sound/magic/clockwork/invoke_general.ogg'
	var/length = 17

/obj/effect/proc_holder/spell/self/bigass_sword/proc/target_bodyparts(atom/the_target) //stolen from gorillacode
	var/list/parts = list()
	if(iscarbon(the_target))
		var/mob/living/carbon/C = the_target
		for(var/X in C.bodyparts)
			var/obj/item/bodypart/BP = X
			if(BP.body_part != HEAD && BP.body_part != CHEST)
				if(BP.dismemberable)
					parts += BP
	return parts

/obj/effect/proc_holder/spell/self/bigass_sword/cast(mob/user = usr)
	user.visible_message("<span class='danger bold'>[user] swings the Big Flaming Sword!</span>")
	var/tip = multistep(user, user.dir, length)
	var/hilt = get_step(user, user.dir)
	var/list/big_sword_hits = getline( hilt, tip )
	var/turf/bA = get_step(multistep(user, user.dir, 2), turn(user.dir, 270))
	big_sword_hits += bA
	var/turf/bB = get_step(multistep(user, user.dir, 2), turn(user.dir, 90))
	big_sword_hits += bB
	for(var/turf/T in big_sword_hits)
		if(T != tip && T != bA && T != bB && T != hilt)
			new /obj/effect/bfs/blade(T, user.dir)
		for(var/mob/living/L in T)
			L.visible_message("<span class='danger'>[L] is hit by the Big Flaming Sword!</span>")
			L.adjustFireLoss(8.75)
			L.adjustBruteLoss(8.75)
			L.fire_stacks += 3
			L.IgniteMob()
			if(prob(35))
				var/list/parts = target_bodyparts(L)
				if(LAZYLEN(parts))
					var/obj/item/bodypart/BP = pick(parts)
					BP.dismember()
					L.visible_message("<span class='danger'>[L]'s [BP] is turned to ashes by the Big Flaming Sword!</span>'", "<span class='userdanger'>Your [BP] is turned to ashes by the Big Flaming Sword!</span>")
					qdel(BP)
					new /obj/effect/decal/cleanable/ash(T)
		for(var/obj/O in T)
			O.visible_message("<span class='danger'>[O] is annihilated by the Big Flaming Sword!</span>")
			O.take_damage(INFINITY) //absolutely destroy any objects
		if(isclosedturf(T))
			T.visible_message("<span class='danger'>[T] is torn away by the Big Flaming Sword!</span>")
			T.ScrapeAway() //tear down to baseturf
	new /obj/effect/bfs/tip(tip, user.dir)
	new /obj/effect/bfs/hilt(get_step(user, user.dir), user.dir)
	explosion(tip, 0, 0, 3, 4, flame_range = 3)

/obj/effect/proc_holder/spell/self/bigass_sword/proc/multistep(ref, dir, amt)
	var/turf/T = get_turf(ref)
	for(var/j=0; j<amt ;j++)
		T = get_step(T, dir)
	return T


/obj/effect/bfs
	icon = 'hippiestation/icons/effects/bfs.dmi'

/obj/effect/bfs/Initialize(mapload, direction)
	. = ..()
	setDir(direction)
	pixel_y = 32
	animate(src, pixel_y = 0, time = 10)
	addtimer(CALLBACK(src, .proc/fire_n_delete), 15)

/obj/effect/bfs/proc/fire_n_delete()
	new /obj/effect/hotspot(get_turf(src))
	qdel(src)

/obj/effect/bfs/tip
	icon_state = "tip"

/obj/effect/bfs/blade
	icon_state = "blade"

/obj/effect/bfs/hilt
	icon_state = "hilt"
