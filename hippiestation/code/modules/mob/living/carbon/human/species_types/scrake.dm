/datum/species/scrake
	name = "Human"
	id = "goofzombies"
	limbs_id = "zombie" //They look like a human
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,NOBLOOD)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	sexes = 0
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_NOBREATH,TRAIT_NOGUNS,TRAIT_PIERCEIMMUNE,TRAIT_SHOCKIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_SLEEPIMMUNE,TRAIT_PUSHIMMUNE,TRAIT_STUNIMMUNE,TRAIT_DISFIGURED)
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	no_equip = list(SLOT_GLOVES, SLOT_SHOES, SLOT_W_UNIFORM, SLOT_S_STORE, SLOT_BACK)
	mutanttongue = /obj/item/organ/tongue/zombie
	mutanteyes = /obj/item/organ/eyes/night_vision/zombie
	armor = 20