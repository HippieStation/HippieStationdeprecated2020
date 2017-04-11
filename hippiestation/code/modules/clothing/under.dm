/obj/item/clothing/under/hippie/cluwne
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	alternate_screams = list('hippiestation/sound/voice/cluwnelaugh1.ogg','hippiestation/sound/voice/cluwnelaugh2.ogg','hippiestation/sound/voice/cluwnelaugh3.ogg')
	icon_state = "cluwne"
	item_state = "cluwne"
	item_color = "cluwne"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags = NODROP | DROPDEL
	can_adjust = 0

/obj/item/clothing/under/hippie/cluwne/equipped(mob/living/carbon/user, slot)
	if(!ishuman(user))
		return
	if(slot == slot_w_uniform)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
		H.reindex_screams()
	return ..()

/obj/item/clothing/suit/toggle/jacket/hippie/custom/jojinam_medals
	name = "old military jacket"
	desc = "an old but well maintained military jacket with lots of army ribbons."
	icon_state = "joji01"
	item_state = "joji01"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/weapon/gun/ballistic/automatic/pistol,/obj/item/weapon/gun/ballistic/revolver,/obj/item/weapon/gun/ballistic/revolver/detective,/obj/item/device/radio)
	togglename = "buttons"

/obj/item/clothing/suit/toggle/jacket/hippie/custom/jojinam
	name = "old military jacket"
	desc = "an old but well maintained military jacket."
	icon_state = "joji02"
	item_state = "joji02"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/weapon/gun/ballistic/automatic/pistol,/obj/item/weapon/gun/ballistic/revolver,/obj/item/weapon/gun/ballistic/revolver/detective,/obj/item/device/radio)
	togglename = "buttons"

//KAZ SHIT\\
/obj/item/clothing/under/hippie/custom/kazsuit
	name = "Olive Suit"
	desc = "an old olive colored suit."
	icon_state = "kazsuit"
	item_state = "kazsuit"

/obj/item/clothing/suit/hippie/custom/kazcoat
	name = "miller's coat"
	desc = "smells like hamburgers."
	icon_state = "kazcoat"
	item_state = "kazcoat"

/obj/item/clothing/shoes/hippie/custom/kazshoes
	name = "miller's shoes"
	desc = "facny."
	icon_state = "kazshoes"
	item_state = "kazshoes"

/obj/item/clothing/gloves/hippie/custom/kazgloves
	name = "miller's gloves"
	desc = "why does a man with one arm need two?"
	icon_state = "kazgloves"
	item_state = "kazgloves"

/obj/item/clothing/head/hippie/custom/kazhat
	name = "miller's beret"
	desc = "a very normal looking beret, with a strange logo on the front."
	icon_state = "kazhat"
	item_state = "kazhat"

/obj/item/clothing/glasses/hippie/custom/kazglasses
	name = "miller's glasses"
	desc = "its too bright."
	icon_state = "kazglasses"
	item_state = "kazglasses"

/obj/item/weapon/cane/custom/kaz
	name = "crutch"
	desc = "a crutch, pretty self explanatory."
	icon = 'hippiestation/icons/obj/Kaz_crutch.dmi'
	icon_state = "Kaz_crutch"
	item_state = "Kaz_crutch"
	force = 5
	throwforce = 5
	lefthand_file = 'hippiestation/icons/mob/Kaz_crutch_left.dmi'
	righthand_file = 'hippiestation/icons/mob/Kaz_crutch_right.dmi'
// END OF THE KAZ SHIT \\