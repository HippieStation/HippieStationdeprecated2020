// haha get it? they're both moons. titan and ganymede.

/datum/species/ganymede
	name = "Ganymedian"
	id = "ganymede"
	species_traits = list(NOTRANSSTING, NOZOMBIE, NO_DNA_COPY, NOEYESPRITES)
	inherent_traits = list(TRAIT_RESISTCOLD, TRAIT_RESISTHEAT, TRAIT_NOLIMBDISABLE, TRAIT_NODISMEMBER, TRAIT_RESISTHIGHPRESSURE, TRAIT_RESISTLOWPRESSURE, TRAIT_STABLEHEART)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	changesource_flags = NONE

/datum/species/ganymede/on_species_gain(mob/living/carbon/human/C, datum/species/old_species, pref_load)
	C.draw_hippie_parts()
	. = ..()

/datum/species/ganymede/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.draw_hippie_parts(TRUE)
	. = ..()
