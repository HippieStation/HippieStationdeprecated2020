/mob/living/carbon/human/create_internal_organs()
	internal_organs += new /obj/item/organ/butt
	return ..()

/mob/living/carbon/human/canSuicide()
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || dna.check_mutation(CLUWNEMUT) in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/canSuccumb()
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || dna.check_mutation(CLUWNEMUT) in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/canGhost()
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || dna.check_mutation(CLUWNEMUT) in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/process_residual_energy()
	. = ..()
	if(dna && istype(dna.species, /datum/species/angel))
		. += 1.5

/mob/living/carbon/human/handle_rejection(datum/magic/MI)
	. = ..()
	if(.)
		bleed(40 * SSmagic.magical_factor)
		bleed_rate = max(bleed_rate + (10 * SSmagic.magical_factor), 10 * SSmagic.magical_factor)
