/datum/species/human/pillarthrall
	name = "\"Human\""
	id = "pthrall"
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_EASYDISMEMBER,TRAIT_LIMBATTACHMENT,TRAIT_NOBREATH)
	inherent_biotypes = list(MOB_HUMANOID, MOB_UNDEAD)
	changesource_flags = MIRROR_BADMIN

/datum/species/human/thrall/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.draw_hippie_parts()

/datum/species/human/thrall/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	C.draw_hippie_parts(TRUE)
