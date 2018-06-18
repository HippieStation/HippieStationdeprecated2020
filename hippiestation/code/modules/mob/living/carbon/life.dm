/mob/living/carbon/breathe()
	if(!getorganslot("breathing_tube"))
		if(pulledby && pulledby.grab_state == GRAB_KILL)
			adjustOxyLoss(1)
	..()

/mob/living/carbon/handle_brain_damage()
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		BT.on_life()

/mob/living/carbon/can_heartattack()
	if(dna && dna.species && (NOBLOOD in dna.species.species_traits)) //not all carbons have species!
		return FALSE
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(heart)
		if(heart.synthetic)
			return FALSE
	if(!heart)
		return NOHEART
	return TRUE

/mob/living/carbon/set_heartattack(status)
	if(!can_heartattack())
		return FALSE

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	heart.beating = !status
