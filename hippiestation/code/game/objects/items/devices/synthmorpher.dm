/obj/item/synthmorpher
	name = "morphic field modifier"
	desc = "Using various quantum phenomena beyond this text's scope, this device changes your bodily architecture to the one of a synth, freeing you from earthly constraints such as oxygen, food, viruses and dismemberment. \
	Also gifts you with a state of the art arm implanted laser gun."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	item_state = "radio"
	var/used = FALSE

/obj/item/synthmorpher/attack_self(mob/living/carbon/M)
	if(!used)
		M.set_species(/datum/species/synth)
		used = TRUE

/obj/item/autosurgeon/armlaser
	starting_organ = /obj/item/organ/cyberimp/arm/gun/laser