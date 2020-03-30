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
	icon = 'hippiestation/icons/obj/clothing/sechats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	alternate_screams = list('hippiestation/sound/voice/stop_right_there.ogg', 'hippiestation/sound/voice/stop_right_there2.ogg')


/obj/item/clothing/head/helmet/sec
	name = "old school helmet"

/obj/item/clothing/head/helmet/sec/hippie
	name = "security cap"
	desc = "Standard Security hat. Has some interior padding to protect the head from impacts."
	icon = 'hippiestation/icons/obj/clothing/sechats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/sechead.dmi'
	icon_state = "sec_hat-1"
	item_state = "sec_hat-1"
	can_flashlight = FALSE

/obj/item/clothing/head/helmet/sec/hippie/custodian
	name = "custodian helmet"
	desc = "A surprisingly large helmet. For when bobby's on the beat."
	icon_state = "sec_hat-2"
	item_state = "sec-hat-2"
	can_flashlight = TRUE

/obj/item/clothing/head/helmet/sec/hippie/custodian/hos
	name = "head of security's custodian helmet"
	desc = "The golden badge shows your experience and ability. Witnesses will stare in awe, or cower in fear."
	icon_state = "hos-hat"
	item_state = "hos-hat"
	can_flashlight = FALSE
	armor = list("melee" = 40, "bullet" = 30, "laser" = 25, "energy" = 10, "bomb" = 25, "bio" = 10, "rad" = 0, "fire" = 50, "acid" = 60)
	strip_delay = 80

/obj/item/clothing/head/helmet/sec/hippie/custodian/hos/spare
	name = "head of security's spare custodian helmet"
	desc = "The 'badge' is just a sticker. It's a shame you're not even remotely as useful as a real custodian." 
