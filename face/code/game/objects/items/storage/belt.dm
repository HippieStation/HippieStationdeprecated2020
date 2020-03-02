

//Hacky solution from clothing.dm
/obj/item/storage/belt/face
	icon = 'face/icons/obj/clothing/belts.dmi'
	alternate_worn_icon = 'face/icons/mob/belt.dmi'

/obj/item/storage/belt/security/webbing/face/
	icon = 'face/icons/obj/clothing/belts.dmi'
	alternate_worn_icon = 'face/icons/mob/belt.dmi'


/obj/item/storage/belt/security/webbing/face/milwebbing/hecu
	name = "standard military webbing"
	desc = "Unique and versatile chest rig fit for a marine, can hold security gear."
	icon_state = "standmilweb"
	item_state = "standmilweb"
	content_overlays = FALSE

/obj/item/storage/belt/security/webbing/face/milwebbing/ComponentInitialize()
	. = ..()
	GET_COMPONENT(STR, /datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.can_hold = typecacheof(list(
		/obj/item/melee/baton,
		/obj/item/melee/classic_baton,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/assembly/flash/handheld,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_box,
		/obj/item/reagent_containers/food/snacks/donut,
		/obj/item/kitchen/knife/combat,
		/obj/item/flashlight/seclite,
		/obj/item/melee/classic_baton/telescopic,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/restraints/legcuffs/bola,
		/obj/item/holosign_creator/security
		))
