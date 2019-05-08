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


/obj/item/clothing/head/hippie/ganymedian
	name = "Ganymedian Helmet"
	desc = "A robust-looking helmet from Ganymede."
	icon_state = "ganymede"
	item_state = "ganymede"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 100, "bio" = 30, "rad" = 30, "fire" = 30, "acid" = 30)

/obj/item/clothing/head/hippie/ganymedian/equipped(mob/user, slot)
	if(slot == SLOT_HEAD)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL

/obj/item/clothing/suit/hippie/ganymedian
	name = "Ganymedian Armor"
	desc = "Robust-looking armor from Ganymede."
	icon_state = "ganymede"
	item_state = "ganymede"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 100, "bio" = 30, "rad" = 30, "fire" = 30, "acid" = 30)

/obj/item/clothing/suit/hippie/ganymedian/equipped(mob/user, slot)
	if(slot == SLOT_WEAR_SUIT)
		ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
		item_flags |= DROPDEL
