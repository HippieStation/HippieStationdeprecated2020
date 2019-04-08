/obj/item/weldingtool/attack(mob/living/carbon/human/H, mob/user)
	if(!istype(H))
		return ..()

	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))

	if(affecting && affecting.status == BODYPART_ROBOTIC && user.a_intent != INTENT_HARM)
		if(use(1))
			playsound(loc, usesound, 50, 1)
			if(user == H)
				item_heal_robotic(H, user, 15, 0)
	else
		return ..()

// TOOLSPEED SETTINGS START
//crowbar

/obj/item/crowbar
	toolspeed = 0.2

/obj/item/crowbar/brass
	toolspeed = 0.175

/obj/item/crowbar/abductor
	toolspeed = 0.1

/obj/item/crowbar/large
	toolspeed = 0.1

/obj/item/crowbar/cyborg
	toolspeed = 0.175

/obj/item/crowbar/power
	toolspeed = 0.175

//screwdriver

/obj/item/screwdriver
	toolspeed = 0.2

/obj/item/screwdriver/brass
	toolspeed = 0.175

/obj/item/screwdriver/abductor
	toolspeed = 0.1

/obj/item/screwdriver/power
	toolspeed = 0.175

/obj/item/screwdriver/cyborg
	toolspeed = 0.175

/obj/item/screwdriver/nuke
	toolspeed = 0.1

//wrench

/obj/item/wrench
	toolspeed = 0.2

/obj/item/wrench/cyborg
	toolspeed = 0.175

/obj/item/wrench/abductor
	toolspeed = 0.1

/obj/item/wrench/power
	toolspeed = 0.175

//wirecutter

/obj/item/wirecutters
	toolspeed = 0.2

/obj/item/wirecutters/brass
	toolspeed = 0.175

/obj/item/wirecutters/abductor
	toolspeed = 0.1

/obj/item/wirecutters/cyborg
	toolspeed = 0.175

/obj/item/wirecutters/power
	toolspeed = 0.175

//TOOLSPEED SETTINGS END

/obj/item/wrench/ghetto
	name = "ghetto wrench"
	desc = "A crude, self-wrought wrench with common uses. Can be found in your hand."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "wrench_ghetto"
	toolspeed = 0.3

/obj/item/crowbar/ghetto
	name = "ghetto crowbar"
	desc = "A crude, self-wrought crowbar. Heavy."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "crowbar_ghetto"
	force = 12 //same as large crowbar, but bulkier
	w_class = WEIGHT_CLASS_BULKY
	toolspeed = 0.3

/obj/item/screwdriver/ghetto
	name = "ghetto screwdriver"
	desc = "Crude driver of screws. A primitive way to screw things up."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "screwdriver_ghetto"
	toolspeed = 0.3
	random_color = FALSE

/obj/item/wirecutters/ghetto
	name = "ghetto wirecutters"
	desc = "Mind your fingers."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "cutters_ghetto"
	toolspeed = 0.3
	random_color = FALSE

/obj/item/weldingtool/ghetto
	name = "ghetto welding tool"
	desc = "A MacGyver-style welder."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "welder_ghetto"
	toolspeed = 0.3
	materials = list(MAT_METAL=140)

/obj/item/multitool/ghetto
	name = "ghetto multitool"
	desc = "As crappy as it is, its still mostly the same as a standard issue Nanotrasen one."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "multitool_ghetto"
	toolspeed = 0.3