////////////////////
/////BODYPARTS/////
////////////////////


/obj/item/bodypart/var/should_draw_hippie = FALSE

/mob/living/carbon/proc/draw_hippie_parts(undo = FALSE)
	if(!undo)
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_hippie = TRUE
	else
		for(var/O in bodyparts)
			var/obj/item/bodypart/B = O
			B.should_draw_hippie = FALSE

/datum/species/proc/hippie_mutant_bodyparts(bodypart, mob/living/carbon/human/H)
	switch(bodypart)
		if("ipc_screen")
			return GLOB.ipc_screens_list[H.dna.features["ipc_screen"]]

/datum/species/proc/hippie_handle_hiding_bodyparts(list/bodyparts_adding, obj/item/bodypart/head/head, mob/living/carbon/human/human)
	if("ipc_screen" in mutant_bodyparts)
		if((human.wear_mask && (human.wear_mask.flags_inv & HIDEFACE)) || (human.head && (human.head.flags_inv & HIDEFACE)) || !head || head.status == BODYPART_ROBOTIC)
			bodyparts_adding -= "ipc_screen"