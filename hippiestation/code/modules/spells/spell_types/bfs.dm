/obj/effect/proc_holder/spell/self/bigass_sword
	name = "Big Flaming Sword"
	desc = "Summons a humungous, flaming sword."
	charge_max = 250
	cooldown_min = 100
	clothes_req = FALSE
	human_req = TRUE
	sound = 'sound/magic/clockwork/invoke_general.ogg'

/obj/effect/proc_holder/spell/self/bigass_sword/cast(mob/user = usr)
	user.visible_message("<span class='danger bold'>[user] swings the Big Flaming Sword!</span>")
	var/tip = multistep(user, user.dir, 17)
	var/list/big_sword_hits = getline( get_step(user, user.dir),  tip )
	big_sword_hits += get_step(multistep(user, user.dir, 2), turn(user.dir, 270))
	big_sword_hits += get_step(multistep(user, user.dir, 2), turn(user.dir, 90))
	for(var/turf/T in big_sword_hits)
		for(var/mob/living/L in T)
			L.visible_message("<span class='danger'>[L] is hit by the Big Flaming Sword!</span>")
			L.adjustFireLoss(8.75)
			L.adjustBruteLoss(8.75)
			L.fire_stacks += 3
			L.IgniteMob()
		for(var/obj/O in T)
			O.visible_message("<span class='danger'>[O] is annihilated by the Big Flaming Sword!</span>")
			O.take_damage(INFINITY) //absolutely destroy any objects
		if(isclosedturf(T))
			T.visible_message("<span class='danger'>[T] is torn away by the Big Flaming Sword!</span>")
			T.ScrapeAway() //tear down to baseturf
		new /obj/effect/hotspot(T)
	explosion(tip, 0, 0, 3, 4, flame_range = 3)

/obj/effect/proc_holder/spell/self/bigass_sword/proc/multistep(ref, dir, amt)
	var/turf/T = get_turf(ref)
	for(var/j=0; j<amt ;j++)
		T = get_step(T, dir)
	return T
