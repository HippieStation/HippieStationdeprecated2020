GLOBAL_LIST_EMPTY(abductortongue_abductors)	//Hippie add, so we can throw people with abductor tongues in one of two teams depending on certain conditions
GLOBAL_LIST_EMPTY(abductortongue_other)


/obj/item/organ/tongue/abductor/handle_speech(datum/source, list/speech_args) //Hippie add, there's now 2 teams so abductors get one channel and everyone else gets another channel
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/crewspeak = FALSE
	var/mob/living/carbon/human/user = source
	if(istype(user))
		var/mob/living/carbon/human/H
		var/rendered = "<span class='abductor'><b>[user.name]:</b> [message]</span>"
		if(user)
			user.log_talk(message, LOG_SAY, tag="Abductor")
			if(user.mind)
				if(user.mind.has_antag_datum(/datum/antagonist/abductor))
					for(H in GLOB.abductortongue_abductors)
						to_chat(H, rendered)
				else
					crewspeak = TRUE
			if(crewspeak == TRUE || !user.mind)
				for(H in GLOB.abductortongue_other)
					to_chat(H, rendered)

			for(var/mob/M in GLOB.dead_mob_list)
				var/link = FOLLOW_LINK(M, user)
				to_chat(M, "[link] [rendered]")

		speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/tongue/abductor/Insert(mob/living/carbon/M, special = 0)	//Hippie add, we add mobs to the global list if they have an abductor tongue so they can get messages
	..()
	var/mob/living/carbon/human/H = M
	var/crewadd = FALSE
	if(H)
		if(H.mind)
			if(H.mind.has_antag_datum(/datum/antagonist/abductor))
				GLOB.abductortongue_abductors += H
			else
				crewadd = TRUE
		if(crewadd == TRUE || !H.mind)
			GLOB.abductortongue_other += H

/obj/item/organ/tongue/abductor/Remove(mob/living/carbon/M, special = 0)	//Hippie add, we need to remove these guys from the global lists if they lose their tongue
	..()
	var/mob/living/carbon/human/H = M
	if(H)
		if(H in GLOB.abductortongue_abductors)
			GLOB.abductortongue_abductors -= H
		if(H in GLOB.abductortongue_other)
			GLOB.abductortongue_other -= H


// Dwarven tongue, they only know their language.
/obj/item/organ/tongue/dwarven
	name = "nol"
	var/static/list/dwarvenLang = typecacheof(list(/datum/language/dwarven))

/obj/item/organ/tongue/dwarven/Initialize(mapload)
	. = ..()
	languages_possible = dwarvenLang
