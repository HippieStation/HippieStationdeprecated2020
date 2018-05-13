GLOBAL_LIST_EMPTY(abductortongue_abductors)	//Hippie add, so we can throw people with abductor tongues in one of two teams depending on certain conditions
GLOBAL_LIST_EMPTY(abductortongue_other)

/obj/item/organ/tongue/abductor/TongueSpeech(var/message)	//Hippie add, there's now 2 teams so abductors get one channel and everyone else gets another channel
	//Hacks
	var/mob/living/carbon/human/user = usr
	var/mob/living/carbon/human/H = user
	var/rendered = "<span class='abductor'><b>[user.name]:</b> [message]</span>"
	log_talk(user,"ABDUCTOR:[key_name(user)] : [rendered]",LOGSAY)
	for(H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(T == /obj/item/organ/tongue/abductor)
			continue
		else
			if(H in GLOB.abductortongue_abductors == src)
				GLOB.abductortongue_abductors -= src
			if(H in GLOB.abductortongue_other == src)
				GLOB.abductortongue_other -= src
			return
		var/datum/antagonist/abductor/A = user.mind.has_antag_datum(/datum/antagonist/abductor)
		if(A || (H.mind in A.team.members))
			if(H in GLOB.abductortongue_abductors != src)	//We don't want to add the same src multiple times
				GLOB.abductortongue_abductors += src
			for(H in GLOB.abductortongue_abductors)
				to_chat(H, rendered)
		else
			if(H in GLOB.abductortongue_other != src)	//We don't want to add the same src multiple times
				GLOB.abductortongue_other += src
			for(H in GLOB.abductortongue_other)
				to_chat(H, rendered)
	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")
	return ""

/obj/item/organ/tongue/abductor/Remove(mob/living/carbon/M, special = 0)	//Hippie add, we need to remove these guys from the global lists if they lose their tongue
	..()
	var/mob/living/carbon/human/H
	if(H in GLOB.abductortongue_abductors == src)
		GLOB.abductortongue_abductors -= src
	if(H in GLOB.abductortongue_other == src)
		GLOB.abductortongue_other -= src