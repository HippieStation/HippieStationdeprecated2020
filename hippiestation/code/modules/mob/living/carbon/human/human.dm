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


/mob/living/carbon/human/Topic(href, href_list)
	..()
	if(href_list["threat"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/H = usr
		if(usr.stat || usr == src)
			return
		if(!H.canUseHUD())
			return
		if(!istype(H.glasses, /obj/item/clothing/glasses/hud/threat))
			return
		to_chat(usr, "<b>Secret/Objective items:</b>")
		for(var/datum/objective_item/O in GLOB.possible_items)
			for(O.targetitem in contents)
				if(!O.targetitem)
					break
				to_chat(usr, "<b>Found:</b> [O.targetitem]")
				return
		to_chat(usr, "<b>None!</b>")
