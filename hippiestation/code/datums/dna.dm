/datum/dna
	var/tts_voice = ""

/datum/dna/proc/create_random_voice()
	var/mob/living/carbon/human/H = holder
	if (H)
		if (H.gender == FEMALE)
			tts_voice = pick("betty", "rita", "ursula", "wendy")
		else
			tts_voice = pick("dennis", "frank", "harry", "kit", "paul")

/datum/dna/initialize_dna(newblood_type, skip_index = FALSE)
	. = ..()
	create_random_voice()

/datum/dna/transfer_identity(mob/living/carbon/destination, transfer_SE = 0)
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

/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, pref_load = FALSE)
	..()
	update_teeth()
	if(is_banned_from(ckey, CATBAN) && !istype(dna.species, /datum/species/tarajan))
		set_species(/datum/species/tarajan, icon_update=1) // can't escape hell

/datum/dna/remove_mutation(mutation_name)
	..()
	if(is_banned_from(holder.ckey, CLUWNEBAN) && !check_mutation(CLUWNEMUT))
		add_mutation(CLUWNEMUT) // you can't escape hell
