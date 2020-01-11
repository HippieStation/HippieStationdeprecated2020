/datum/species/ipc
	name = "IPC"
	id = "ipc"
	say_mod = "beeps"
	default_color = "00FF00"
	sexes = 0
	species_traits = list(MUTCOLORS,NOEYESPRITES)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("ipc_screen")
	default_features = list("ipc_screen" = "Sunburst")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

/datum/species/ipc/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	RegisterSignal(C, COMSIG_MOB_SAY, .proc/handle_speech)
	. = ..()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	UnregisterSignal(C, COMSIG_MOB_SAY)
	. = ..()

/datum/species/ipc/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/datum/species/ipc/check_roundstart_eligible()
	return TRUE
