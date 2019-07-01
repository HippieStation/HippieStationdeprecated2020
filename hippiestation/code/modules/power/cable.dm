/obj/item/stack/cable_coil
	max_amount = 30
	amount = 30

/obj/item/stack/cable_coil/Initialize(mapload, new_amount = null, param_color = null)
	.=..()
	recipes = list(new/datum/stack_recipe("cable restraints", /obj/item/restraints/handcuffs/cable, 15), new/datum/stack_recipe("noose", /obj/structure/chair/noose, 30, time = 80, one_per_turf = 1, on_floor = 1))


/obj/item/stack/cable_coil/attack(mob/living/carbon/human/H, mob/user)
	if(!istype(H))
		return ..()

	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(affecting && affecting.status == BODYPART_ROBOTIC)
		if(user == H)
			if(item_heal_robotic(H, user, 0, 15))
				use(1)
			return
	else
		return ..()
