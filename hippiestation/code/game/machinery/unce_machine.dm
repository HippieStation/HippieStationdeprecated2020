/obj/machinery/unce
	name = "unce machine"
	desc = "Unce unce unce..."
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "unce_machine"
	max_integrity = 200
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)
	circuit = /obj/item/circuitboard/machine/unce
	var/speed = 4.5 //Speed at which unces are played. This default speed is a good rythm.
	var/speed_state = 1
	var/on = TRUE
	var/unce_file = 'hippiestation/sound/machines/unce.ogg'
	var/list/settings = list("Adjust unce speed", "Adjust unce sound")
	var/list/unce_sounds = list("Classic unce", "Disco unce")

/obj/machinery/unce/Initialize()
	. = ..()
	loopUnce()

/obj/machinery/unce/attack_hand(mob/living/user)
	. = ..()
	if(stat & NOPOWER || stat & BROKEN || on == FALSE)
		return
	var/option = input(user, "Choose an option", "Unce machine settings") in null|settings
	switch(option)
		if("Adjust unce speed")
			if(unce_file == 'hippiestation/sound/machines/disco_unce.ogg') //This file lasts too long for the player to have free reign over its speed.
				to_chat(user, "<span class ='warning'>You can't change the unce speed with the currently selected unce sound!</span>")
				return
			speed = input(user, "Ranges from 1-10 \nHigher number: slower unce \nLower number: faster unce", "Unce machine settings") as null|num
			if(speed == null)
				speed = 4.5 //Default value
			if(speed < 1)
				speed = 1
			if(speed > 10)
				speed = 10
			to_chat(user, "<span class ='notice'>You adjust the unce speed to [speed].</span>")
		if("Adjust unce sound")
			var/chosen_sound = input(user, "Select the sound of the unce.", "Unce machine settings") in null|unce_sounds
			switch(chosen_sound)
				if(null)
					return
				if("Classic unce")
					unce_file = 'hippiestation/sound/machines/unce.ogg'
				if("Disco unce")
					speed = 10
					unce_file = 'hippiestation/sound/machines/disco_unce.ogg'

/obj/machinery/unce/AltClick(mob/living/user)
	. = ..()
	on = !on
	if(on == TRUE)
		to_chat(user, "<span class ='notice'>You turn the [src] on.</span>")
		loopUnce()
	else
		to_chat(user, "<span class ='notice'>You turn the [src] off.</span>")

/obj/machinery/unce/examine(mob/user)
	. = ..()
	. += "<span class='info'>Alt-click to toggle on/off."

/obj/machinery/unce/proc/checkStuff()
	if(stat & NOPOWER || stat & BROKEN || on == FALSE)
		return FALSE
	return TRUE

/obj/machinery/unce/proc/loopUnce()
	while(TRUE)
		if(checkStuff() == TRUE)
			playsound(src, unce_file, 50, 0)
			sleep(speed)
		else
			return