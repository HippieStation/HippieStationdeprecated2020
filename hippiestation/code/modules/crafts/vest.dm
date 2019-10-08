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

/obj/item/clothing/suit/armor/plate_armor/steel
	name = "plate armor"
	desc = "A suit of plate armor."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	item_state = "plate_armor"
	icon_state = "plate_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/claymore, /obj/item/forged/melee/sword, /obj/item/forged/melee/dagger, /obj/item/twohanded/forged/greatsword, /obj/item/forged/melee/mace,/obj/item/nullrod)
	armor = list("melee" = 40, "bullet" = 20, "laser" = -10, "energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	resistance_flags = ACID_PROOF
	clothing_flags = THICKMATERIAL
	w_class = WEIGHT_CLASS_BULKY
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.6

/obj/item/clothing/head/helmet/plate_armor
	name = "plate armor helm"
	desc = "A solid helm of metal. It is exceedingly heavy and makes your neck ache."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "metal_helmet"
	item_state = "metal_helmet"
	armor = list("melee" = 40, "bullet" = 15, "laser" = -10,"energy" = -10, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	resistance_flags = ACID_PROOF
	flags_inv = HIDEMASK | HIDEEARS| HIDEEYES| HIDEFACE| HIDEHAIR| HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	clothing_flags = THICKMATERIAL

/obj/item/clothing/suit/armor/plate_armor/steel/Initialize(obj/item/I)
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	new /obj/item/clothing/head/helmet/plate_armor(loc)

/obj/item/clothing/head/helmet/plate_armor/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)

/**********************************         **********************************/
/********************************** Recipes **********************************/
/**********************************         **********************************/

/datum/crafting_recipe/plate_armor
	name = "plate armor"
	result =  /obj/item/clothing/suit/armor/plate_armor/steel
	reqs = list(/obj/item/stack/sheet/metal = 50,
				/obj/item/weldingtool)
	time = 30 //time gating is a shit concept
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
