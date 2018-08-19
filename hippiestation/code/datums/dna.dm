/datum/dna
	var/tts_voice = ""

/datum/dna/proc/create_random_voice()
	var/mob/living/carbon/human/H = holder
	if (H)
		if (H.gender == FEMALE)
			tts_voice = pick("betty", "rita", "ursula", "wendy")
		else
			tts_voice = pick("dennis", "frank", "harry", "kit", "paul")

/datum/dna/initialize_dna()
	. = ..()
	create_random_voice()

/datum/dna/transfer_identity(mob/living/carbon/destination)
	. = ..()
	if (!istype(destination))
		return
	destination.dna.tts_voice = tts_voice

/datum/dna/copy_dna(datum/dna/new_dna)
	. = ..()
	if (new_dna)
		new_dna.tts_voice = tts_voice

/datum/dna/update_dna_identity()
	. = ..()
	create_random_voice()
