//Carrier Code - Colonial Marines - Last Edit: Apophis775 - 11JUN16

/mob/living/carbon/Xenomorph/Carrier
	caste = "Carrier"
	name = "Carrier"
	desc = "A strange-looking alien creature. It carries a number of scuttling jointed crablike creatures."
	icon = 'icons/xeno/2x2_Xenos.dmi' //They are now like, 2x2
	icon_state = "Carrier Walking"
	melee_damage_lower = 20
	melee_damage_upper = 30
	tacklemin = 2
	tacklemax = 3
	tackle_chance = 60
	health = 175
	maxHealth = 175
	storedplasma = 50
	maxplasma = 250
	jelly = 1
	jellyMax = 800
	plasma_gain = 8
	evolves_to = list() //Add more here seperated by commas
	caste_desc = "A carrier of huggies."
	var/huggers_max = 6
	var/huggers_cur = 0
	var/throwspeed = 1
	var/threw_a_hugger = 0
	var/hugger_delay = 40
	tier = 3
	upgrade = 0
	adjust_pixel_x = -16 //Needed for 2x2
	// adjust_pixel_y = -6  //Needed for 2x2
	// adjust_size_x = 0.8  //Needed for 2x2
	// adjust_size_y = 0.75  //Needed for 2x2

	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/plant,
		/mob/living/carbon/Xenomorph/proc/regurgitate,
		/mob/living/carbon/Xenomorph/proc/transfer_plasma,
		/mob/living/carbon/Xenomorph/Carrier/proc/throw_hugger,
		/mob/living/carbon/Xenomorph/proc/tail_attack,
		/mob/living/carbon/Xenomorph/proc/toggle_auras,
		/mob/living/carbon/Xenomorph/proc/secure_host
		)


/mob/living/carbon/Xenomorph/Carrier/Stat()
	..()
	stat(null, "Stored Huggers: [huggers_cur] / [huggers_max]")


/mob/living/carbon/Xenomorph/Carrier/ClickOn(var/atom/A, params)
//FUCK SHIFT CLICK! FUCK YOUUUUUUUU. SHIFT CLICK IS EXAMINE!
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && middle_mouse_toggle)
		throw_hugger(A) //Just try to chuck it, throw_hugger has all the required checks anyway
		return
	if(modifiers["shift"] && shift_mouse_toggle)
		throw_hugger(A) //Just try to chuck it, throw_hugger has all the required checks anyway
		return
	..()

/mob/living/carbon/Xenomorph/Carrier/proc/throw_hugger(var/mob/living/carbon/T)
	set name = "Throw Facehugger"
	set desc = "Throw one of your facehuggers. MIDDLE MOUSE BUTTON quick-throws."
	set category = "Alien"

	if(!check_state())	return
	//This shit didn't wanna go into the upgrade area...
	if(upgrade == 1)
		huggers_max = 7
		hugger_delay = 30
	if(upgrade == 2)
		huggers_max = 8
		hugger_delay = 20
	if(upgrade == 3)
		huggers_max = 10
		hugger_delay = 10

	var/mob/living/carbon/Xenomorph/Carrier/X = src
	if(!istype(X))
		src << "How did you get this verb??" //Lel. Shouldn't be possible, butcha never know. Since this uses carrier-only vars
		return

	if(X.huggers_cur <= 0)
		src << "\red You don't have any facehuggers to throw!"
		return

	if(!X.threw_a_hugger)
		if(!T)
			var/list/victims = list()
			for(var/mob/living/carbon/human/C in oview(7))
				victims += C
			T = input(src, "Who should you throw at?") as null|anything in victims
		if(T)
			X.threw_a_hugger = 1
			var/obj/item/clothing/mask/facehugger/newthrow = new()
			X.huggers_cur -= 1
			newthrow.loc = src.loc
			newthrow.throw_at(T, 5, X.throwspeed)
			// src << "You throw a facehugger at [T]."
			visible_message("\red <B>[src] throws something towards [T]!</B>")
			spawn(hugger_delay)
				X.threw_a_hugger = 0
		else
			src << "\blue You cannot throw at nothing!"
	return



