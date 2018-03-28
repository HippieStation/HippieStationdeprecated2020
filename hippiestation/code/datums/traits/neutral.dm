/* Hippie Neutral Traits */
/datum/trait/dwarf
	name = "Dwarfism"
	desc = "You were born a halfling, and as such aren't as fast as your able-bodied friends."
	value = 0
	gain_text = "<span class='notice'>You feel the world suddenly grow bigger.</span>"
	lose_text = "<span class='notice'>You feel like a normal height again.</span>"
	medical_record_text = "Patient suffers from achondroplasia."

/datum/trait/dwarf/add()
	var/mob/living/carbon/human/H = trait_holder
	H.dna.add_mutation(DWARFISM)

/datum/trait/dwarf/remove()
	var/mob/living/carbon/human/H = trait_holder
	H.dna.remove_mutation(DWARFISM)
