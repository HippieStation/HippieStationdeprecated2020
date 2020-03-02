

/obj/item/storage/backpack/face/
	icon = 'face/icons/obj/storage.dmi'
	alternate_worn_icon = 'face/icons/mob/back.dmi'

/obj/item/storage/backpack/face/ComponentInitialize()
	. = ..()
	GET_COMPONENT(STR, /datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 21

/obj/item/storage/backpack/face/examine(mob/user)
	..()
	clothing_resistance_flag_examine_message(user)

/obj/item/storage/backpack/face/hecubag
	name = "Hazardous Environment Bag"
	desc = "You wear this on your back and put items into it."
	icon_state = "hecubag"
	item_state = "hecubag"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK	//ERROOOOO
	resistance_flags = FIRE_PROOF
