/datum/species/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	if(H.checkbuttinsert(I, user))
		return FALSE

	return ..()

/datum/species/movement_delay(mob/living/carbon/human/H)
	. = ..()

	if (H.dna.check_mutation(DWARFISM))
		. += 0.2