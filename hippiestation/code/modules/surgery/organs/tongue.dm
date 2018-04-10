/obj/item/organ/tongue/abductor/TongueSpeech(var/message)
	//Hacks
	var/mob/living/carbon/human/user = usr
	var/rendered = "<span class='abductor'><b>[user.name]:</b> [message]</span>"
	log_talk(user,"ABDUCTOR:[key_name(user)] : [rendered]",LOGSAY)
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
		if(!T || T.type != type)
			continue
		if(H.dna && H.dna.species.id == "abductor" && user.dna && user.dna.species.id == "abductor")
			to_chat(H, rendered)
	for(var/mob/M in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(M, user)
		to_chat(M, "[link] [rendered]")
	return ""