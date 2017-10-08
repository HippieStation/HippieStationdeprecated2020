#define HORN_BRAIN_DAMAGE 10

/obj/item/bikehorn/golden/retardhorn
	origin_tech = "engineering=4;syndicate=3" //Science can uncover if this is a regular bike horn or not using science goggles.

/obj/item/bikehorn/golden/retardhorn/attack()
	flip_mobs()
	retardify()
	return ..()

/obj/item/bikehorn/golden/retardhorn/attack_self(mob/user)
	flip_mobs()
	retardify()
	..()

/obj/item/bikehorn/golden/retardhorn/proc/retardify(mob/living/carbon/M, mob/user)
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(ishuman(M) && M.can_hear())
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		M.adjustBrainLoss(HORN_BRAIN_DAMAGE)
		log_admin("[key_name(user)] dealt brain damage to [key_name(M)] with the Extra annoying bike horn")

#undef HORN_BRAIN_DAMAGE
