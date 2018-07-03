/mob/living/carbon/human
	see_invisible = SEE_INVISIBLE_LIVING	//This will give the human the potential ability to see ghosts, while others cannot.
	var/ghostvision = FALSE		//Boolean for the update_sight proc

/mob/living/carbon/human/proc/toggle_ghostvision()	//This is the proc to run in order to change the variable so they can see/unsee ghosts
	if(client)
		if(ghostvision == FALSE)
			ghostvision = TRUE
			update_ghost_sight()
		else
			ghostvision = FALSE
			update_ghost_sight()

/mob/living/carbon/human/proc/update_ghost_sight()	//This will allow individual humans to potentially see ghosts
	if(!ghostvision)
		see_invisible = SEE_INVISIBLE_LIVING
	else
		see_invisible = SEE_INVISIBLE_OBSERVER

/mob/living/carbon/human/create_internal_organs()
  internal_organs += new /obj/item/organ/butt
  return ..()

/mob/living/carbon/human/canSuicide()
	var/datum/mutation/human/HM = GLOB.mutations_list[CLUWNEMUT]
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || HM in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/canSuccumb()
	var/datum/mutation/human/HM = GLOB.mutations_list[CLUWNEMUT]
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || HM in dna.mutations)
		return FALSE
	else
		return ..()

/mob/living/carbon/human/canGhost()
	var/datum/mutation/human/HM = GLOB.mutations_list[CLUWNEMUT]
	if(dna.species.id == "tarajan" || dna.species.id == "meeseeks" || HM in dna.mutations)
		return FALSE
	else
		return ..()