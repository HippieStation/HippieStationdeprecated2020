//Recycled Amari code. Supposed to be for poo staining but everything about it is broken, will fix later.

/obj/item/clothing
  var/poo_stained = 0

/obj/item/clothing/suit/update_clothes_damaged_state()
	. = ..()
	if(poo_stained)
		add_overlay(mutable_appearance('hippiestation/icons/effects/poo.dmi', "poo[blood_overlay_type]"))
/*
/obj/item/clothing/proc/clean_blood()
	. = ..()
	poo_stained = min(poo_stained-1, 0)
	update_clothes_damaged_state()

ERROR: DUPLICATE DEFINITION. */