/obj/item/mine //Better than the /obj/effect mines
	name = "dummy mine"
	desc = "Better stay away from that thing."
	density = FALSE
	anchored = 0
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine_off"
	var/off_icon_state = "uglymine_off"
	var/on_icon_state = "uglymine"
	var/triggered = 0
	var/armed = FALSE

/obj/item/mine/proc/mineEffect(mob/victim)
	to_chat(victim, "<span class='danger'>*click*</span>")

/obj/item/mine/Crossed(AM as mob|obj)
	if(isturf(loc))
		if(ismob(AM))
			var/mob/MM = AM
			if(!(MM.movement_type & FLYING))
				triggermine(AM)
		else
			triggermine(AM)

/obj/item/mine/proc/triggermine(mob/victim)
	if(triggered)
		return
	if(!armed)
		return
	visible_message("<span class='danger'>[victim] sets off [icon2html(src, viewers(src))] [src]!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	mineEffect(victim)
	triggered = 1
	qdel(src)

/obj/item/mine/interact(mob/living/user)
	armed = !armed
	if(armed)
		icon_state = on_icon_state
		update_icon()
		to_chat(user, "<span class ='notice'>You arm the mine. Once dropped it cannot be picked up!</span>")
		playsound(src,'sound/items/timer.ogg', 50)
	else
		icon_state = off_icon_state
		update_icon()
		to_chat(user, "<span class ='notice'>You disarm the mine.</span>")
		playsound(src, 'sound/items/screwdriver2.ogg', 50)

/obj/item/mine/pickup(mob/user)
	if(armed)
		src.visible_message("<span class ='danger'>[user] picks up the [src], setting it off!</span>")
		triggermine(user)

/obj/item/mine/explosive
	name = "explosive mine"
	var/range_devastation = 0
	var/range_heavy = 1
	var/range_light = 2
	var/range_flash = 3

/obj/item/mine/explosive/mineEffect(mob/victim)
	explosion(loc, range_devastation, range_heavy, range_light, range_flash)


/obj/item/mine/stun
	name = "stun mine"
	var/stun_time = 80

/obj/item/mine/stun/mineEffect(mob/living/victim)
	if(isliving(victim))
		victim.Paralyze(stun_time)

/obj/item/mine/kickmine
	name = "kick mine"

/obj/item/mine/kickmine/mineEffect(mob/victim)
	if(isliving(victim) && victim.client)
		to_chat(victim, "<span class='userdanger'>You have been kicked FOR NO REISIN!</span>")
		qdel(victim.client)


/obj/item/mine/gas
	name = "oxygen mine"
	var/gas_amount = 360
	var/gas_type = "o2"

/obj/item/mine/gas/mineEffect(mob/victim)
	atmos_spawn_air("[gas_type]=[gas_amount]")


/obj/item/mine/gas/plasma
	name = "plasma mine"
	gas_type = "plasma"


/obj/item/mine/gas/n2o
	name = "\improper N2O mine"
	gas_type = "n2o"


/obj/item/mine/sound
	name = "honkblaster 1000"
	var/sound = 'sound/items/bikehorn.ogg'

/obj/item/mine/sound/mineEffect(mob/victim)
	playsound(loc, sound, 100, 1)


/obj/item/mine/sound/bwoink
	name = "bwoink mine"
	sound = 'sound/effects/adminhelp.ogg'

/obj/item/mine/disco
	name = "disco dance mine"
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "disco_mine_off"
	on_icon_state = "disco_mine"
	off_icon_state = "disco_mine_off"
	var/list/dancefloor_turfs
	var/list/dancefloor_turfs_types
	var/dancefloor_exists = FALSE
	var/direction

/obj/item/mine/disco/mineEffect(mob/living/victim) //Shamelessly ripped from the devil's dance spell
	LAZYINITLIST(dancefloor_turfs)
	LAZYINITLIST(dancefloor_turfs_types)
	var/list/funky_turfs = RANGE_TURFS(1, victim)

	if(dancefloor_exists)
		dancefloor_exists = FALSE
		for(var/i in 1 to dancefloor_turfs.len)
			var/turf/T = dancefloor_turfs[i]
			T.ChangeTurf(dancefloor_turfs_types[i], flags = CHANGETURF_INHERIT_AIR)
	else
		dancefloor_exists = TRUE
		var/i = 1
		dancefloor_turfs.len = funky_turfs.len
		dancefloor_turfs_types.len = funky_turfs.len
		for(var/t in funky_turfs)
			var/turf/T = t
			if(!(istype(T, /turf/closed))) //Don't want walls turning into dance floors or else this mine will be the next thermite.
				dancefloor_turfs[i] = T
				dancefloor_turfs_types[i] = T.type
				T.ChangeTurf((i % 2 == 0) ? /turf/open/floor/light/colour_cycle/dancefloor_a : /turf/open/floor/light/colour_cycle/dancefloor_b, flags = CHANGETURF_INHERIT_AIR)
				i++
	playsound(src, 'sound/items/party_horn2.ogg', 50)
	playsound(src, 'sound/items/ISayDisco.ogg', 100)
	for(var/mob/living/M in range(1, get_turf(victim)))
		victim = M
		victim.AdjustImmobilized(100)
		victim.emote("spin")
		victim.emote("snap")
		victim.visible_message("<span class ='danger'>[victim] begins to uncontrollably DANCE!</span>")
		addtimer(CALLBACK(src, .proc/discoDance, victim), 1)

/obj/item/mine/disco/proc/discoDance(mob/living/victim)
	var/i
	for(i = 1; i <= 10; i++)
		victim.emote("flip")
		victim.emote("spin")
		sleep(10)

/obj/item/mine/disco/triggermine(mob/victim)
	if(triggered)
		return
	if(!armed)
		return
	visible_message("<span class='danger'>[victim] sets off [icon2html(src, viewers(src))] [src]!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	mineEffect(victim)
	triggered = 1

	//This is the next best thing to deletion. If I do qdel(src) then discoDance() doesn't have enough time to activate
	icon_state = null
	update_icon()
	mouse_opacity = 0
	addtimer(CALLBACK(src, .proc/delete_self), 300) //30 seconds to account for mega lag

/obj/item/mine/disco/proc/delete_self()
	qdel(src)