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
	toolspeed = 0.5

/obj/item/crowbar/ghetto
	name = "ghetto crowbar"
	desc = "A crude, self-wrought crowbar. Heavy."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "crowbar_ghetto"
	force = 12 //same as large crowbar, but bulkier
	w_class = WEIGHT_CLASS_BULKY
	toolspeed = 0.5

/obj/item/screwdriver/ghetto
	name = "ghetto screwdriver"
	desc = "Crude driver of screws. A primitive way to screw things up."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "screwdriver_ghetto"
	toolspeed = 0.5
	random_color = FALSE

/obj/item/wirecutters/ghetto
	name = "ghetto wirecutters"
	desc = "Mind your fingers."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "cutters_ghetto"
	toolspeed = 0.5
	random_color = FALSE

/obj/item/weldingtool/ghetto
	name = "ghetto welding tool"
	desc = "A MacGyver-style welder."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "welder_ghetto"
	toolspeed = 0.5
	materials = list(MAT_METAL=140)
	max_fuel = 10

/obj/item/multitool/ghetto
	name = "ghetto multitool"
	desc = "As crappy as it is, its still mostly the same as a standard issue Nanotrasen one."
	icon = 'hippiestation/icons/obj/tools.dmi'
	icon_state = "multitool_ghetto"
	toolspeed = 0.5

/obj/item/wirecutters/ghetto/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(prob(5))
		to_chat(usr, "<span class='danger'>[src] crumbles apart in your hands!</span>")
		qdel(src)
		return

/obj/item/crowbar/ghetto/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(prob(2))
		to_chat(user, "<span class='danger'>[src] crumbles apart in your hands!</span>")
		qdel(src)
		return
		...()

/obj/item/screwdriver/ghetto/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(prob(5))
		to_chat(user, "<span class='danger'>[src] crumbles apart in your hands!</span>")
		qdel(src)
		return

/obj/item/wrench/ghetto/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(prob(2))
		to_chat(user, "<span class='danger'>[src] crumbles apart in your hands!</span>")
		qdel(src)
		return

/obj/item/multitool/ghetto/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(prob(5))
		user.rad_act(20)
		to_chat(user, "<span class='userdanger'>[src] breaks down and emits dangerous rays!</span>")
		src.tool_behaviour = 0
		return

/obj/item/weldingtool/ghetto/switched_on(mob/user)
	if(!status)
		to_chat(user, "<span class='warning'>[src] can't be turned on while unsecured!</span>")
		return
	welding = !welding
	if(welding)
		if(get_fuel() >= 1)
			to_chat(user, "<span class='notice'>You switch [src] on.</span>")
			playsound(loc, acti_sound, 50, 1)
			force = 15
			if(prob(2))
				var/datum/effect_system/reagents_explosion/e = new()
				to_chat(user, "<span class='userdanger'>Shoddy construction causes [src] to blow the fuck up!</span>")
				e.set_up(round(reagents.get_reagent_amount("welding_fuel") / 10, 1), get_turf(src), 0, 0)
				e.start()
				qdel(src)
				return
			damtype = "fire"
			hitsound = 'sound/items/welder.ogg'
			update_icon()
			START_PROCESSING(SSobj, src)
		else
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			switched_off(user)
	else
		to_chat(user, "<span class='notice'>You switch [src] off.</span>")
		playsound(loc, deac_sound, 50, 1)
		switched_off(user)