/* Research Director Syndie teleporter */
/obj/item/device/experimental_teleporter
	name = "experimental teleporter"
	desc = "An imperfect teleportation device."
	icon = 'icons/hippie/obj/device.dmi'
	icon_state = "spe_teleporter"
	force = 0
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	materials = list(MAT_METAL=10000)
	origin_tech = "magnets=4;bluespace=6;syndicate=5"
	var/cooldown = 6 /* 0.6 sec cd */
	var/active = TRUE
	var/timerID

/obj/item/device/experimental_teleporter/attack_self(mob/user)
	if(!active)
		return
	active = FALSE

	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.start()

	playsound(get_turf(user), 'sound/hippie/effects/teleport.ogg', 40, 1)

	user.visible_message("<span class='warning'>[user.name] teleports away!</span>")

	/* Teleport. If they go out of bounds, then stop processing */
	var/turf/newTurf = teleport(user)
	if(!newTurf)
		return

	if(isclosedturf(newTurf)) /* If you get stuck in a closed turf, you die */
		user.emote("scream")
		user << "<span class='userdanger'>You scream out in pain as your body materialises inside of the [newTurf.name]!</span>"
		active = TRUE /* so that it's not perma broke */
		user.gib()
		return

	for(var/mob/living/victim in newTurf)
		if(victim == user)
			continue
		var/body = "body"
		if(issilicon(victim))
			body = "chassis"
		victim << "<span class='userdanger'>You scream out in pain as your [body] is ripped apart by [user.name]!</span>"
		victim.emote("scream")
		victim.gib()

	timerID = addtimer(CALLBACK(src, .proc/reactivate), cooldown, TIMER_STOPPABLE)


/* Does the teleport if not out of bounds, returns the turf on successful teleport */
/obj/item/device/experimental_teleporter/proc/teleport(mob/user)
	var/dist = rand(3, 5)
	var/turf/oldTurf = get_turf(user)
	var/turf/newTurf

	switch(user.dir)
		if(NORTH)
			newTurf = locate(oldTurf.x, oldTurf.y + dist, oldTurf.z)
		if(SOUTH)
			newTurf = locate(oldTurf.x, oldTurf.y - dist, oldTurf.z)
		if(EAST)
			newTurf = locate(oldTurf.x + dist, oldTurf.y, oldTurf.z)
		if(WEST)
			newTurf = locate(oldTurf.x - dist, oldTurf.y, oldTurf.z)

	if(!newTurf) /* Teleported out of the map itself */
		user << "<span class='userdanger'>You scream out- No, wait, you're already dead. You've become one with the void itself.</span>"
		user.death(1)
		user.ghostize()
		qdel(user)
		return

	user.forceMove(newTurf)
	return newTurf

/obj/item/device/experimental_teleporter/proc/reactivate()
	active = TRUE
	timerID = null

/obj/item/device/experimental_teleporter/Destroy()
	if(timerID)
		deltimer(timerID)
	return ..()