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
		for(var/obj/item/I in GetAllContents())
			for(var/datum/objective_item/O in GLOB.possible_items)
				if(!O || !GLOB.possible_items)
					to_chat(usr, "<b>Error finding objective database</b>")
				if(istype(I, O.targetitem) && O.check_special_completion(I))
					to_chat(usr, "<b>Found:</b> [I]")
					break
			if(istype(I, /obj/item/card/id))
				var/obj/item/card/id/auth_card = I
				if(auth_card && ((ACCESS_CHANGE_IDS in auth_card.access) || (ACCESS_SECURITY in auth_card.access) || (ACCESS_ARMORY in auth_card.access)))
					to_chat(usr, "<b>Access card of interest: [auth_card]</b>")
		to_chat(usr, "<b>Scan complete</b>")
