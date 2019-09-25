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

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_CLUWNE, "Make Cluwne")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_CLUWNE])
		if(!check_rights(R_SPAWN))
			return
		cluwneify()
		message_admins("<span class='notice'>[key_name(usr)] has made [key_name(src)] into a Cluwne.</span>")
