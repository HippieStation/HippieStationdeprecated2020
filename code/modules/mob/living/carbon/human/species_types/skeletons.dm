/datum/species/skeleton
	// 2spooky
	name = "Super Scary Skeleton"
	id = "skeleton"
	say_mod = "rattles"
	blacklisted = 1
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	species_traits = list(NOBREATH,RESISTHOT,RESISTCOLD,RESISTPRESSURE,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE,NOHUNGER,EASYDISMEMBER,EASYLIMBATTACHMENT)
	mutant_organs = list(/obj/item/organ/tongue/bone)
	damage_overlay_type = ""//let's not show bloody wounds or burns over bones.

/datum/species/skeleton/playable
	name = "Spooky Scary Skeleton"
	id = "spookyskeleton"
	say_mod = "rattles"
	blacklisted = 0
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	mutant_organs = list(/obj/item/organ/tongue/bone)
	damage_overlay_type = ""//let's not show bloody wounds or burns over bones.
	limbs_id = "skeleton"