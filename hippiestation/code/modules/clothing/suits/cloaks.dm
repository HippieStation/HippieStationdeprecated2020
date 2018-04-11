/obj/item/clothing/neck/cloak
	w_class = WEIGHT_CLASS_NORMAL	//Classified as normal instead of small items to prevent infinite storage capabilities!!!
	slot_flags = SLOT_BACK | SLOT_NECK
	cold_protection = CHEST | ARMS | HANDS
	min_cold_protection_temperature = 257
	//Cloaks keep your chest, arms, and hands toasty, but only slightly. For reference, humans start taking cold damage at 260.15K.
	pockets = /obj/item/storage/internal/pocket/small/cloak //Cloaks now have 2 pocket slots! :D

obj/item/clothing/neck/cloak/equipped(mob/living/carbon/human/user, slot)
	if(slot == slot_neck)
		pockets.quick_empty(pockets, contents)
		pockets = null
		to_chat(user, "<span class='notice'>You empty the cloak's pockets as you don it...</span>")
	else
		pockets = /obj/item/storage/internal/pocket/small/cloak

/obj/item/clothing/neck/cloak/black
	name = "black cloak"
	desc = "A dark-colored cloak. Appears to have 2 pockets inside."
	alternate_worn_icon = 'hippiestation/icons/mob/cloaks.dmi'
	icon = 'hippiestation/icons/obj/clothing/back.dmi'
	icon_state = "blackcloak"

/obj/item/clothing/neck/cloak/green
	name = "\improper Unathi cloak"
	desc = "A traditional green cloak commonly worn by the Unathi and by humans who have been gifted them."
	alternate_worn_icon = 'hippiestation/icons/mob/cloaks.dmi'
	icon = 'hippiestation/icons/obj/clothing/back.dmi'
	icon_state = "greencloak"