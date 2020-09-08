/obj/item/clothing/shoes/sneakers/black/noslip
	clothing_flags = NOSLIP

/obj/item/clothing/shoes/sneakers/brown/noslip
	clothing_flags = NOSLIP

/obj/item/clothing/shoes/dwarf
	alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'
	name = "dwarf shoes"
	icon = 'hippiestation/icons/obj/clothing/shoes.dmi'
	icon_state = "dwarf"
	item_color = "dwarf"
	item_state = "dwarf"
	desc = "A pair of dwarven boots. Basically toddler shoes."

/obj/item/clothing/shoes/viceofficer
	name = "vice officer's dress shoes"
	alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'
	icon = 'hippiestation/icons/mob/feet.dmi'
	icon_state = "dress-white"
	item_color = "dress-white"

/obj/item/clothing/shoes/bronze/slow
    name = "Ratvar's Boots of Deceleration"
    desc = "A cruel joke forged by the machine god himself. Just looking at them makes you feel lethargic."
    slowdown = SHOES_SLOWDOWN+4
    resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/shoes/hobo_swep
	name = "angry_hobo_swep"
	desc = "R + left click: throw boot | Ctrl + S while equiped: scream"
	icon = 'hippiestation/icons/obj/clothing/shoes.dmi'
	icon_state = "hoboswep"
	item_state = "hoboswep"
	force = 5
	throwforce = 7
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_FEET
	alternate_worn_icon = null
	alternate_screams = list('hippiestation/sound/voice/hoboswep1.ogg','hippiestation/sound/voice/hoboswep2.ogg','hippiestation/sound/voice/hoboswep3.ogg','hippiestation/sound/voice/hoboswep5.ogg','hippiestation/sound/voice/hoboswep6.ogg')

/obj/item/clothing/shoes/hobo_swep/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == ITEM_SLOT_HEAD)
		alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
		body_parts_covered = HEAD
		user.update_inv_head()
	else if(slot == ITEM_SLOT_FEET)
		alternate_worn_icon = 'hippiestation/icons/mob/feet.dmi'
		body_parts_covered = FEET
		user.update_inv_shoes()