/obj/item/clothing/suit/armor/makeshift
	name = "makeshift armor"
	desc = "A hazard vest with metal plate taped on it. It offers minor protection."
	icon = 'hippiestation/icons/obj/armor.dmi'
	alternate_worn_icon = 'hippiestation/icons/obj/armor.dmi'
	icon_state = "makeshiftarmor-worn"
	item_state = "makeshiftarmor"
	w_class = 3
	blood_overlay_type = "armor"
	armor = list("melee" = 30, "bullet" = 10, "laser" = 0, "energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0)

/datum/crafting_recipe/makeshift_armor
	name = "makeshift armor"
	result =  /obj/item/clothing/suit/armor/makeshift
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/clothing/suit/hazardvest = 1,
				/obj/item/stack/ducttape = 5)
	time = 80
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/obj/item/clothing/suit/armor/plate
	name = "plate armor"
	desc = "A suit of plate armor, it menaces with spikes of gray. It is so heavy one cannot be pushed down while inside it."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	item_state = "plate_armor"
	icon_state = "plate_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("melee" = 50, "bullet" = 15, "laser" = -10, "energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	blocks_shove_knockdown = TRUE
	resistance_flags = ACID_PROOF
	w_class = WEIGHT_CLASS_BULKY
	var/padded = FALSE
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.6

/obj/item/clothing/suit/armor/plate/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/armor/plate/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/armor/plate/attackby(obj/item/I, mob/user, params)
	if((istype(I, /obj/item/stack/sheet/cloth)) && (src != padded))
		if(istype(I, use(10)))
			to_chat(user, "You pad the insides of the [src] with [I].")
			src.padded = 1.
			src.desc += "This one is padded, and thus it is easier to move comfortably while wearing it."
			src.slowdown = 0
		else
			to_chat(user, "You are not using a sufficient quantity of cloth to properly soften the [src]'s interior..")
	else
		to_chat(user, "[src] is already padded")
	..()

/obj/item/clothing/head/helmet/plate_armor
	name = "plate armor helm"
	desc = "A solid helm of metal. It is exceedingly heavy and makes your neck ache."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "metal_helmet"
	item_state = "metal_helmet"
	armor = list("melee" = 40, "bullet" = 15, "laser" = -10,"energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/claymore, /obj/item/forged/melee/sword, /obj/item/forged/melee/dagger, /obj/item/twohanded/forged/greatsword, /obj/item/forged/melee/mace,/obj/item/nullrod)
	resistance_flags = ACID_PROOF
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	clothing_flags = THICKMATERIAL

/obj/item/clothing/head/helmet/plate_armor/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/plate_armor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/armor/plate/plasteel
	name = "plasteel plate armor"
	desc = "A suit of plasteel plate armor, it menaces with spikes of light-gray. It is so heavy one cannot be pushed down while inside it."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	item_state = "plate_armor_plasteel"
	icon_state = "plate_armor_plasteel"
	armor = list("melee" = 50, "bullet" = 25, "laser" = 5, "energy" = 5, "bomb" = 25, "bio" = 25, "rad" = 30, "fire" = 10, "acid" = 80)
	blocks_shove_knockdown = TRUE
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.8

/obj/item/clothing/head/helmet/plate_armor/plasteel
	name = "plasteel plate armor helm"
	desc = "A solid helm of plasteel. It is exceedingly heavy and makes your neck ache."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "plasteel_helmet"
	item_state = "plasteel_helmet"
	armor = list("melee" = 50, "bullet" = 25, "laser" = 5,"energy" = 5, "bomb" = 25, "bio" = 25, "rad" = 30, "fire" = 10, "acid" = 80)

/datum/crafting_recipe/plate_armor
	name = "plate armor"
	result =  /obj/item/clothing/suit/armor/plate
	reqs = list(/obj/item/stack/sheet/metal = 40,
				/obj/item/weldingtool)
	time = 30 //time gating is a shit concept
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/plate_armor_helmet
	name = "plate armor helmet"
	result =  /obj/item/clothing/head/helmet/plate_armor
	reqs = list(/obj/item/stack/sheet/metal = 10,
				/obj/item/weldingtool)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/plate_armor_plasteel
	name = "plasteel plate armor"
	result =  /obj/item/clothing/suit/armor/plate/plasteel
	reqs = list(/obj/item/stack/sheet/plasteel = 40,
				/obj/item/weldingtool)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/plate_armor_helmet_plasteel
	name = "plasteel plate armor helmet"
	result =  /obj/item/clothing/head/helmet/plate_armor/plasteel
	reqs = list(/obj/item/stack/sheet/plasteel = 10,
				/obj/item/weldingtool)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON