/obj/item/clothing/mask/gas/wrestling
	name = "wrestling mustache"
	icon = 'icons/hippie/obj/sports.dmi'
	desc = "A high-tech space mustache that can connect to an air tank."
	icon_state = "mustache"
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	w_class = WEIGHT_CLASS_SMALL
	flash_protect = 2
	item_state = "mustache"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSMOUTH
	resistance_flags = FIRE_PROOF

/obj/item/clothing/glasses/wrestling
	name = "wrestling goggles"
	icon = 'icons/hippie/obj/sports.dmi'
	desc = "Makes sure that nothing gets in your way when you're trying to wrestle."
	icon_state = "wrestlinggoggles"
	flash_protect = 2
	flags_cover = GLASSESCOVERSEYES
	visor_flags_inv = HIDEEYES
	glass_colour_type = /datum/client_colour/glass_colour/gray

/obj/item/clothing/under/wrestling
	name = "wrestling unitard"
	icon = 'icons/hippie/obj/sports.dmi'
	desc = "Doesn't do much, but looks stylish as Hell."
	icon_state = "unitard"
	can_adjust = FALSE

/obj/item/clothing/under/wrestling/New()
	color = pick("white","green","yellow")
	..()

/obj/item/weapon/storage/box/syndie_kit/wrestling
	name = "squared-circle smackdown set"

/obj/item/weapon/storage/box/syndie_kit/wrestling/New()
	..()
	new /obj/item/clothing/mask/gas/wrestling(src)
	new /obj/item/clothing/glasses/wrestling(src)
	new /obj/item/clothing/under/wrestling(src)
	new /obj/item/weapon/storage/belt/champion/wrestling(src)