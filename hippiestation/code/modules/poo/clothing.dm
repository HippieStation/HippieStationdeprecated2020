/obj/item/clothing
  var/poo_stained = FALSE
  var/pee_stained = FALSE

/obj/item/clothing/update_clothes_damaged_state()
	. = ..()
	if(poo_stained)
		add_overlay(mutable_appearance('hippiestation/icons/obj/poo.dmi', "poo[blood_overlay_type]"))

/obj/item/clothing/clean_blood()
	. = ..()
	poo_stained = FALSE
	pee_stained = FALSE
	update_clothes_damaged_state()