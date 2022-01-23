/obj/machinery/vending/cart/old
	name = "\improper Old machine"
	desc = "You can't make out what the description says. It looks like an old vending machine of some sort..."
	product_slogans = "BzZZzz-zt;ZZzShBhT;W*Ee#w!lLD3st0R-RyYoU!BZZT"
	icon_state = "cart-broken"
	icon_deny = "cart-broken"
	products = list(/obj/item/cartridge/medical = 2,
		            /obj/item/cartridge/engineering = 1,
		            /obj/item/cartridge/security = 1,
					/obj/item/cartridge/janitor = 1,
					/obj/item/cartridge/signal/toxins = 1,
					/obj/item/pda/heads = 3,
					/obj/item/cartridge/captain = 1,
					/obj/item/cartridge/quartermaster = 0)
	default_price = 5
	extra_price = 10
	scan_id = FALSE

/obj/machinery/vending/cart
	light_color = LIGHT_COLOR_PINK