/mob/living/carbon/human

/mob/living/carbon/human/Initialize()
	. = ..()
	update_teeth()

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
