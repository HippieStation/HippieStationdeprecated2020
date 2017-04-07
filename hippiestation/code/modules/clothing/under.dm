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
