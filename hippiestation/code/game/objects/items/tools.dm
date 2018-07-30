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

// TOOLSPEED REMOVAL/equal rights
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
