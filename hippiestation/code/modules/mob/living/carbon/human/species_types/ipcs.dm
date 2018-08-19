/datum/species/ipc
	name = "IPC"
	id = "ipc"
	say_mod = "beeps"
	default_color = "00FF00"
	blacklisted = 0
	sexes = 0
	species_traits = list(MUTCOLORS,NOEYES)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	mutant_bodyparts = list("ipc_screen")
	default_features = list("ipc_screen" = "Sunburst")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/ipc

/datum/species/ipc/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	. = ..()

/datum/species/ipc/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/ipc/get_spans()
	return SPAN_ROBOT

/datum/species/ipc/check_roundstart_eligible()
	return TRUE
