/obj/item/organ/tongue/abductor/TongueSpeech(var/message)	//Hippie add, there's now 2 teams so abductors get one channel and everyone else gets another channel
	//Hacks
	var/mob/living/carbon/human/user = usr
	var/mob/living/carbon/human/H
	var/rendered = "<span class='abductor'><b>[user.name]:</b> [message]</span>"
	log_talk(user,"ABDUCTOR:[key_name(user)] : [rendered]",LOGSAY)
	var/datum/antagonist/abductor/A = user.mind.has_antag_datum(/datum/antagonist/abductor)
	if(A || (H.mind in A.team.members))
		var/mob/living/carbon/human/H/abductor = H
		for(H in GLOB.alive_mob_list)
			var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
			if(!T || T.type != type)
				continue
				to_chat(H, rendered)
	else
		var/mob/living/carbon/human/H/other = H
		for(H in GLOB.alive_mob_list)
			var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
			if(!T || T.type != type)
				continue
				to_chat(H, rendered)
	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")
	return ""