/obj/effect/proc_holder/spell/self/bigass_sword
	name = "Big Flaming Sword"
	desc = "Summons a humungous, flaming sword."
	charge_max = 350
	cooldown_min = 150
	clothes_req = FALSE
	human_req = TRUE
	sound = 'sound/magic/clockwork/invoke_general.ogg'
	var/length = 9

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
	chugga_chugga(get_turf(user), user.dir, 1)

/obj/effect/proc_holder/spell/self/bigass_sword/proc/chugga_chugga(turf/T, direction, chugga_amount)
	var/turf/tip = multistep(T, direction, chugga_amount)
	//var/hilt = get_step(T, direction)
	QDEL_IN(new /obj/effect/bfs/tip(tip, direction), 0.5)
	for(var/mob/living/L in tip)
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
	for(var/obj/O in tip)
		if(!istype(O, /obj/effect/bfs))
			O.visible_message("<span class='danger'>[O] is annihilated by the Big Flaming Sword!</span>")
			O.take_damage(INFINITY) //absolutely destroy any objects
	if(isclosedturf(tip))
		tip.visible_message("<span class='danger'>[tip] is torn away by the Big Flaming Sword!</span>")
		tip.ScrapeAway() //tear down to baseturf
	if (chugga_amount > 1)
		for(var/turf/A in getline(get_step(T, direction), tip)-tip)
			QDEL_IN(new /obj/effect/bfs/blade(A, direction), 0.5)
	if(chugga_amount < length)
		addtimer(CALLBACK(src, .proc/chugga_chugga, T, direction, chugga_amount+1), 1)yy
	else
		explosion(tip, 0, 0, 3, 4, flame_range = 3)
		

/obj/effect/proc_holder/spell/self/bigass_sword/proc/multistep(ref, dir, amt)
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
