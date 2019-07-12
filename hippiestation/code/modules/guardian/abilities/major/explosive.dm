/datum/guardian_ability/major/explosive
	name = "Explosive"
	desc = "The power to turn any object into a bomb."
	cost = 4
	var/bomb_cooldown = 0

/datum/guardian_ability/major/explosive/Attack(atom/target)
	if(prob(40) && isliving(target))
		var/mob/living/M = target
		if(!M.anchored && M != guardian.summoner && !guardian.hasmatchingsummoner(M))
			new /obj/effect/temp_visual/guardian/phase/out(get_turf(M))
			do_teleport(M, M, 10, channel = TELEPORT_CHANNEL_BLUESPACE)
			for(var/mob/living/L in range(1, M))
				if(guardian.hasmatchingsummoner(L)) //if the summoner matches don't hurt them
					continue
				if(L != guardian && L != guardian.summoner)
					L.apply_damage(15, BRUTE)
			new /obj/effect/temp_visual/explosion(get_turf(M))

/datum/guardian_ability/major/explosive/AltClickOn(atom/A)
	if(!istype(A))
		return
	if(guardian.loc == guardian.summoner)
		to_chat(guardian, "<span class='danger'><B>You must be manifested to create bombs!</B></span>")
		return
	if(isobj(A) && guardian.Adjacent(A))
		if(bomb_cooldown <= world.time && !guardian.stat)
			var/obj/guardian_bomb/B = new /obj/guardian_bomb(get_turf(A))
			to_chat(guardian, "<span class='danger'><B>Success! Bomb armed!</B></span>")
			bomb_cooldown = world.time + 200
			B.spawner = guardian
			B.disguise(A, master_stats.persistence * 18 * 10) // 90 seconds at level A persistence, 18 at Level F persistence.
		else
			to_chat(src, "<span class='danger'><B>Your powers are on cooldown! You must wait 20 seconds between bombs.</B></span>")

// the bomb
/obj/guardian_bomb
	name = "bomb"
	desc = "You shouldn't be seeing this!"
	var/obj/stored_obj
	var/mob/living/simple_animal/hostile/guardian/spawner

/obj/guardian_bomb/proc/disguise(obj/A, time)
	A.forceMove(src)
	stored_obj = A
	opacity = A.opacity
	anchored = A.anchored
	density = A.density
	appearance = A.appearance
	addtimer(CALLBACK(src, .proc/disable), time)

/obj/guardian_bomb/proc/disable()
	stored_obj.forceMove(get_turf(src))
	to_chat(spawner, "<span class='danger'><B>Failure! Your trap didn't catch anyone this time.</B></span>")
	qdel(src)

/obj/guardian_bomb/proc/detonate(mob/living/user)
	if(isliving(user))
		if(user != spawner && user != spawner.summoner && !spawner.hasmatchingsummoner(user))
			to_chat(user, "<span class='danger'><B>[src] was boobytrapped!</B></span>")
			to_chat(spawner, "<span class='danger'><B>Success! Your trap caught [user]</B></span>")
			var/turf/T = get_turf(src)
			stored_obj.forceMove(T)
			playsound(T,'sound/effects/explosion2.ogg', 200, 1)
			new /obj/effect/temp_visual/explosion(T)
			user.ex_act(EXPLODE_HEAVY)
			qdel(src)
		else
			to_chat(user, "<span class='holoparasite'>[src] glows with a strange <font color=\"[spawner.namedatum.colour]\">light</font>, and you don't touch it.</span>")

/obj/guardian_bomb/Bumped(atom/A)
	detonate(A)
	..()

/obj/guardian_bomb/attackby(mob/living/user)
	detonate(user)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/guardian_bomb/attack_hand(mob/living/user)
	detonate(user)

/obj/guardian_bomb/examine(mob/user)
	. = stored_obj.examine(user)
	if(get_dist(user,src)<=2)
		. += "<span class='holoparasite'>It glows with a strange <font color=\"[spawner.namedatum.colour]\">light</font>!</span>"
