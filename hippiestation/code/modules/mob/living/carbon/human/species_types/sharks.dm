/datum/species/shark
	name = "Sharkman"
	id = "shark"
	say_mod = "bubbles"
	blacklisted = 0
	species_traits = list(EYECOLOR,LIPS)
	attack_verb = "chomp"
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/bird

/datum/species/shark/on_species_gain(mob/living/carbon/human/C)
	C.draw_hippie_parts()
	. = ..()

/datum/species/shark/on_species_loss(mob/living/carbon/human/C)
	C.draw_hippie_parts(TRUE)
	. = ..()