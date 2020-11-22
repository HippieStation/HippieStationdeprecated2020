/obj/machinery/unce_machine
	name = "unce machine"
	desc = "Unce unce unce..."
	icon = 'hippiestation/icons/obj/machines/radio_station.dmi'
	icon_state = "unce_machine"
	max_integrity = 200
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	power_channel = AREA_USAGE_EQUIP
	idle_power_usage = 2
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 20)
	circuit = /obj/item/circuitboard/machine/unce_machine
	var/speed = 4.5 //Speed at which unces are played. This default speed is a good rythm for classic unce.
	var/on = TRUE
	var/unce_file = 'hippiestation/sound/machines/unce.ogg'
	var/unce_name = "Classic unce" //Displayed in the first input()
	var/list/settings = list("Adjust unce speed", "Adjust unce sound")
	var/list/unce_sounds = list("Classic unce", "Disco unce")
	var/loopinprogress = FALSE //Prevent multiple loopUnces() from occuring when alt-click is spammed

/obj/machinery/unce_machine/proc/checkStuff() //Checks if the loop should stop
	if(stat & NOPOWER || stat & BROKEN || on == FALSE)
		return FALSE
	return TRUE

/obj/machinery/unce_machine/proc/loopUnce() //Loops the unce sound
	loopinprogress = TRUE
	if(checkStuff())
		playsound(src, unce_file, 100, 0, 2)
		pixel_y += 2
		addtimer(CALLBACK(src, .proc/loopUnce), speed)
		addtimer(CALLBACK(src, .proc/move_to_the_beat), 4)
	else
		return

/obj/machinery/unce_machine/proc/move_to_the_beat() //Moves it back down
	pixel_y = 0

/obj/machinery/unce_machine/Initialize()
	. = ..()
	loopUnce()

/obj/machinery/unce_machine/attack_hand(mob/living/user)
	. = ..()
	if(stat & NOPOWER || stat & BROKEN || on == FALSE)
		return
	var/option = input(user, "Current unce speed: [speed] \n Current unce sound: [unce_name]", "Unce machine settings") as null|anything in settings
	switch(option)
		if("Adjust unce speed")
			if(unce_file == 'hippiestation/sound/machines/disco_unce.ogg') //This file lasts too long for the player to have free reign over its speed.
				to_chat(user, "<span class ='warning'>You can't change the unce speed with the currently selected unce sound!</span>")
				return
			speed = input(user, "Ranges from 1-10 \nHigher number: slower unce \nLower number: faster unce", "Unce machine settings") as null|num
			if(isnull(speed))
				speed = 4.5 //Default value
			if(speed < 1)
				speed = 1
			if(speed > 10)
				speed = 10
			to_chat(user, "<span class ='notice'>You adjust the unce speed to [speed].</span>")
		if("Adjust unce sound")
			var/chosen_sound = input(user, "Select the sound of the unce.", "Unce machine settings") as null|anything in unce_sounds
			switch(chosen_sound)
				if(null)
					return
				if("Classic unce")
					unce_file = 'hippiestation/sound/machines/unce.ogg'
					unce_name = "Classic unce"
				if("Disco unce")
					speed = 10 //Disco unce sounds bad unless the speed is set to a higher number.
					unce_file = 'hippiestation/sound/machines/disco_unce.ogg'
					unce_name = "Disco unce"

/obj/machinery/unce_machine/AltClick(mob/living/user)
	. = ..()
	on = !on
	if(on)
		to_chat(user, "<span class ='notice'>You turn the [src] on.</span>")
		if(loopinprogress)
			loopUnce()
	else
		loopinprogress = FALSE
		to_chat(user, "<span class ='notice'>You turn the [src] off.</span>")

/obj/machinery/unce_machine/examine(mob/user)
	. = ..()
	. += "<span class='info'>Alt-click to toggle on/off.</span>"