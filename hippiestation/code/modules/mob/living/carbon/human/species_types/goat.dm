/datum/species/goat
	// Joji's fetish (and mine)
	name = "Goat"
	id = "goat"
	default_color = "FFFFFF"
	say_mod = "bleats"
	sexes = 1
	blacklisted = 0
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/goat
	skinned_type = /obj/item/stack/sheet/animalhide/human

/datum/species/goat/on_species_gain(mob/living/carbon/human/C)
	C.draw_hippie_parts()
	. = ..()

/datum/species/goat/on_species_loss(mob/living/carbon/human/C)
	C.draw_hippie_parts(TRUE)
	. = ..()