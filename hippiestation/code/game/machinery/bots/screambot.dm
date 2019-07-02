/obj/item/screambot_chasis
	desc = "A chasis for a new screambot."
	name = "screambot chasis"
	icon = 'hippiestation/icons/obj/aibots_new.dmi'
	icon_state = "screambot_chasis"
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/build_step = 0

/obj/item/screambot_chasis/attackby(obj/item/W, mob/user)
	..()
	var/hotness = W.is_hot()
	if(hotness && build_step <= 0)
		to_chat(user, "<span class='notice'>You weld some holes in [src].</span>")
		build_step = 1
		desc += " It has weird holes in it that resemble a face."
		icon_state = "screambot_chasis1"
	else if((istype(W, /obj/item/bodypart/l_arm/robot) || istype(W, /obj/item/bodypart/r_arm/robot)) && build_step == 1)
		to_chat(user, "<span class='notice'>You complete the screambot!</span>")
		user.dropItemToGround()
		qdel(W)
		var/turf/T = get_turf(src)
		new/mob/living/simple_animal/bot/screambot(T)
		qdel(src)

/mob/living/simple_animal/bot/screambot
	name = "screambot"
	desc = "SCREAMING INTENSIFIES."
	icon = 'hippiestation/icons/obj/aibots_new.dmi'
	icon_state = "screambot"
	layer = 5.0
	density = 0
	anchored = 0
	health = 25
	var/cooldown = 0
	var/speedup = 1
	var/probability = 30
	var/list/sounds = list('hippiestation/sound/voice/scream_f1.ogg', 'hippiestation/sound/voice/scream_f2.ogg', \
	'hippiestation/sound/voice/scream_m1.ogg', 'hippiestation/sound/voice/scream_m2.ogg', \
	'hippiestation/sound/voice/scream_silicon.ogg', \
	'hippiestation/sound/voice/cat.ogg', 'hippiestation/sound/voice/caw.ogg', 'hippiestation/sound/voice/scream_lizard.ogg', 'hippiestation/sound/voice/scream_moth.ogg', 'hippiestation/sound/voice/scream_skeleton.ogg')

/mob/living/simple_animal/bot/screambot/explode()
	visible_message("<span class='userdanger'>[src] blows apart!</span>")
	var/turf/T = get_turf(src)
	if(prob(50))
		new /obj/item/bodypart/l_arm/robot(T)

	var/datum/effect_system/spark_spread/s = new
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/oil(loc)
	..() //qdels us and removes us from processing objects

/mob/living/simple_animal/bot/screambot/Initialize()
	. = ..()
	icon_state = "screambot[on]"

/mob/living/simple_animal/bot/screambot/turn_on()
	..()
	icon_state = "screambot[on]"

/mob/living/simple_animal/bot/screambot/turn_off()
	..()
	icon_state = "screambot[on]"

/mob/living/simple_animal/bot/screambot/handle_automated_action()
	if (!..())
		return

	if(cooldown < world.time && prob(probability)) //Probability so it's not TOO annoying (-atlantique except when its emagged lmao)
		cooldown = world.time + 100 / speedup
		if(sounds.len)
			playsound(loc, pick(sounds), 50, 1, 7, 1.2)
		flick("screambot_scream", src)
		visible_message("<span class='danger'><b>[src]</b> screams!</span>")

	. = ..()

/mob/living/simple_animal/bot/screambot/emag_act(mob/user)
	if(!emagged)
		emagged = 1
		speedup = 10
		probability = 100
		to_chat(user, "<span class='warning'>Nice. The screambot is going to be really, REALLY annoying now.</span>")

//MENU

//Commented out because it's really old cold that carely works any more.
/*
/mob/living/simple_animal/bot/screambot/attack_hand(mob/user)
	var/dat = "<div class='statusDisplay'>"
	dat += "Human scream: <A href='?src=\ref[src];action=toggle;scream=human'>[('hippiestation/sound/voice/scream_f1.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Synthesized scream: <A href='?src=\ref[src];action=toggle;scream=silicon'>[('hippiestation/sound/voice/scream_silicon.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Cat scream: <A href='?src=\ref[src];action=toggle;scream=cat'>[('hippiestation/sound/voice/cat.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Lizard scream: <A href='?src=\ref[src];action=toggle;scream=lizard'>[('hippiestation/sound/voice/scream_lizard.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	dat += "Bird scream: <A href='?src=\ref[src];action=toggle;scream=caw'>[('hippiestation/sound/voice/caw.ogg' in sounds) ? "On" : "Off"]</A><BR>"
	var/datum/browser/popup = new(user, "screambot", name, 300, 300)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/bot/screambot/Topic(href, href_list)
	if(..() || panel_open)
		return

	if(href_list["action"] == "toggle")
		switch(href_list["scream"])
			if("human")
				if('sound/misc/scream_f1.ogg' in sounds)
					sounds -= 'sound/misc/scream_f1.ogg'
					sounds -= 'sound/misc/scream_f2.ogg'
					sounds -= 'sound/misc/scream_m1.ogg'
					sounds -= 'sound/misc/scream_m2.ogg'
				else
					sounds += 'sound/misc/scream_f1.ogg'
					sounds += 'sound/misc/scream_f2.ogg'
					sounds += 'sound/misc/scream_m1.ogg'
					sounds += 'sound/misc/scream_m2.ogg'
			if("silicon")
				if('sound/voice/screamsilicon.ogg' in sounds)
					sounds -= 'sound/voice/screamsilicon.ogg'
				else
					sounds += 'sound/voice/screamsilicon.ogg'
			if("cat")
				if('sound/misc/cat.ogg' in sounds)
					sounds -= 'sound/misc/cat.ogg'
				else
					sounds += 'sound/misc/cat.ogg'
			if("lizard")
				if('sound/misc/lizard.ogg' in sounds)
					sounds -= 'sound/misc/lizard.ogg'
				else
					sounds += 'sound/misc/lizard.ogg'
			if("caw")
				if('sound/misc/caw.ogg' in sounds)
					sounds -= 'sound/misc/caw.ogg'
				else
					sounds += 'sound/misc/caw.ogg'

	updateUsrDialog() // This line here is the problem, fucks up the compile.
	return	*/
