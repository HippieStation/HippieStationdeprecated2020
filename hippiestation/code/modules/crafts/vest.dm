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
	desc = "A suit of plate armor, it menaces with spikes of gray. It's so heavy one cannot be pushed down while inside it."
	icon = 'hippiestation/icons/obj/clothing/suits.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/suit.dmi'
	item_state = "plate_armor"
	icon_state = "plate_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("melee" = 50, "bullet" = 40, "laser" = -15, "energy" = -15, "bomb" = 15, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80)
	blocks_shove_knockdown = TRUE
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.6

/obj/item/clothing/head/plate_armor_helmet
	name = "plate armor helm"
	desc = "A solid helm of metal. It is exceedingly heavy and makes your neck ache."
	icon = 'hippiestation/icons/obj/clothing/hats.dmi'
	alternate_worn_icon = 'hippiestation/icons/mob/head.dmi'
	icon_state = "plate_armor_helmet"
	item_state = "plate_armor_helmet"
	armor = list("melee" = 40, "bullet" = 40, "laser" = -15,"energy" = -15, "bomb" = 25, "bio" = 25, "rad" = 20, "fire" = -15, "acid" = 80) //stats copied from the security helmet, with melee and bullet buffed and vulnerability to any thermal source
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	resistance_flags = NONE
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR
	slowdown = 0.6

/datum/crafting_recipe/plate_armor
	name = "plate armor"
	result =  /obj/item/clothing/suit/armor/plate
	reqs = list(/obj/item/stack/sheet/metal = 150,
				/obj/item/weldingtool)
	time = 30 //time gating is a shit concept
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/plate_armor_helmet
	name = "plate armor helmet"
	result =  /obj/item/clothing/head/plate_armor_helmet
	reqs = list(/obj/item/stack/sheet/metal = 70,
				/obj/item/weldingtool)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON