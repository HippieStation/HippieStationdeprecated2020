/datum/species/moth
	// Shitty moths, why do we need them dammit
	name = "Mothmen"
	id = "moth"
	say_mod = "flutters"
	default_color = "00FF00"
	species_traits = list(LIPS)
	mutant_bodyparts = list("moth_wings")
	default_features = list("moth_wings" = "Plain")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	roundstart = TRUE

/datum/species/moth/on_species_gain(mob/living/carbon/human/C)
	C.draw_hippie_parts()
	. = ..()

/datum/species/moth/on_species_loss(mob/living/carbon/human/C)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/moth/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_moth_name(gender)

	var/randname = moth_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/moth/qualifies_for_rank(rank, list/features)
	if(rank in GLOB.command_positions)
		return 0
	return 1

// Procs edited on tg files:
//1) Added add_hippie_choices(dat) proc to preferences, in the lines showing the various mutant bodyparts choices
//2) Added hippie_pref_load(savefile/S) and hippie_pref_save(savefile/S) proc to preferences_savefile, to load and save custom hippie stuff like moth wings choices
//3) Added moth_wings, along with their entry in the random_features proc inside mobs.dm in __HELPERS