/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	teeth_type = /obj/item/stack/teeth/lizard
/*
 Lizard subspecies: ASHWALKERS
*/

/datum/outfit/ashwalker/post_equip(mob/living/carbon/human/H)
	H.remove_all_languages() //Ashwalkers can only speak Draconic
	H.grant_language(/datum/language/draconic)
