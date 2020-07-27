/obj/item/clothing/head/helmet/knight
	alternate_screams = list('hippiestation/sound/voice/deus_vult.ogg')

/obj/item/clothing/head/helmet/larp //Skyrim, coming to BYOND in 2078!
	name = "guard helmet"
	desc = "A close-faced helmet. Protects the head from loose arrows and swords."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	icon_state = "guardhelm"
	item_state = "guardhelm"
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	alternate_screams = list('hippiestation/sound/voice/stop_right_there.ogg', 'hippiestation/sound/voice/stop_right_there2.ogg')

/obj/item/clothing/head/helmet/redtaghelm/afromaker
	name = "Afro Maker"
	desc = "To wear this helmet is to accept its creator."
	color = "#FF0000"
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/head/helmet/redtaghelm/afromaker/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == ITEM_SLOT_HEAD)
		user.hair_style = "Afro (Large)"
		user.update_hair()
