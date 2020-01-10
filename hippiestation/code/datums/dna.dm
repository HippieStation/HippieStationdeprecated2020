/datum/dna
	var/tts_voice = ""

/datum/dna/proc/create_random_voice()
	var/mob/living/carbon/human/H = holder
	if (H)
		if (H.gender == FEMALE)
			var/voices = splittext(CONFIG_GET(string/tts_voice_female), ",")
			tts_voice = pick(LAZYLEN(voices) ? voices : list("slt"))
		else
			var/voices = splittext(CONFIG_GET(string/tts_voice_male), ",")
			tts_voice = pick(LAZYLEN(voices) ? voices : list("ap", "kal", "awb", "kal16", "rms"))

/datum/dna/initialize_dna(newblood_type, skip_index = FALSE)
	. = ..()
	create_random_voice()
	if(is_banned_from(holder.ckey, CLUWNEBAN) && !check_mutation(CLUWNEMUT))
		add_mutation(CLUWNEMUT) // you can't escape hell

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
	if(is_banned_from(ckey, CATBAN) && !istype(dna.species, /datum/species/human/felinid/tarajan))
		set_species(/datum/species/human/felinid/tarajan, icon_update=1) // can't escape hell
	if(is_banned_from(holder.ckey, CLUWNEBAN) && !check_mutation(CLUWNEMUT))
		add_mutation(CLUWNEMUT) // you can't escape hell

/datum/dna/remove_mutation(mutation_name)
	..()
	if(is_banned_from(holder.ckey, CLUWNEBAN) && !check_mutation(CLUWNEMUT))
		add_mutation(CLUWNEMUT) // you can't escape hell
