/obj/item/clothing/mask/vape
	icon_hippie = 'hippiestation/icons/obj/clothing/masks.dmi'

/obj/item/lighter
	overlay_state = "zoppo"

/obj/item/lighter/greyscale
	overlay_state = null

/obj/item/lighter/slime
	overlay_state = "slime"

/obj/item/lighter/Initialize()
	. = ..()
	update_icon()