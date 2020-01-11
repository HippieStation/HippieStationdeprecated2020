/obj/item/clothing/mask/breath/dwarf
	name = "obscenely small breath mask"
	desc = "Mysteriously gets shorter the moment you put it on."
	icon_state = null // you'll only see this through adminbus any way
	item_state = null

/datum/outfit/dwarf
	name = "Dwarf"
	uniform = /obj/item/clothing/under/dwarf
	shoes = /obj/item/clothing/shoes/dwarf
	ears = /obj/item/radio/headset
	back = /obj/item/storage/backpack
	mask = /obj/item/clothing/mask/breath/dwarf
	r_pocket = /obj/item/tank/internals/dwarf
	id = /obj/item/card/id

/datum/outfit/dwarf/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	H.set_species(/datum/species/dwarf)
	H.gender = MALE
	var/new_name = H.dna.species.random_name(H.gender, TRUE)
	H.fully_replace_character_name(H.real_name, new_name)
	H.regenerate_icons()
	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Dwarf"
	W.registered_name = H.real_name
	W.update_label()
	W.access = list(ACCESS_MAINT_TUNNELS)
	var/obj/item/tank/internals/dwarf/T = H.r_store
	T.toggle_internals(H)