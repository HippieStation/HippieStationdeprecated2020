/obj/item/mine
	name = "dummy mine"
	desc = "Better stay away from that thing."
	density = FALSE
	anchored = FALSE
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0

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
	visible_message("<span class='danger'>[victim] sets off [icon2html(src, viewers(src))] [src]!</span>")
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	mineEffect(victim)
	triggered = 1
	qdel(src)


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