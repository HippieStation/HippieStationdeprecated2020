/datum/species/bird
	// flappy bird
	name = "Avian"
	id = "avian"
	say_mod = "squawks"
	default_color = "00FF00"
	blacklisted = 0
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	attack_verb = "claw"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/bird

/datum/species/bird/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	. = ..()

/datum/species/bird/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	. = ..()

/datum/species/bird/check_roundstart_eligible()
	return TRUE
