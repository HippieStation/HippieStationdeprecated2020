/obj/item/organ/tongue/abductor/TongueSpeech(var/message)
	//Hacks
	var/mob/living/carbon/human/user = usr
	var/rendered_abductor = "<span class='abductor'><b>[user.name]:</b> [message]</span>"
	var/rendered_else = "<span class='abductor'><b>[user.name]:</b> [message]</span>"
	log_talk(user,"ABDUCTOR:[key_name(user)] : [rendered_abductor]",LOGSAY)
	log_talk(user,"ABDUCTOR:[key_name(user)] : [rendered_else]",LOGSAY)
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(!T || T.type != type)
			continue
			var/datum/antagonist/abductor/A = user.mind.has_antag_datum(/datum/antagonist/abductor)
			if(!A || !(H.mind in A.team.members))
				to_chat(H, rendered_abductor)
			else
				to_chat(H, rendered_else)
	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered_abductor]")
		to_chat(M, "[link] [rendered_else]")
	return ""