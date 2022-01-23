/obj/machinery/vending/citadelplush
	name = "\improper Citadel's Plushies"
	desc = "Buy Plushies here."
	product_slogans = "Im John Mantis, And this, is my favourite vending machine!"
	product_ads = ""
	icon_state = "citadelplush"
	light_color = LIGHT_COLOR_PINK
	products = list(/obj/item/toy/plush/carpplushie = 5,
				   /obj/item/toy/plush/bubbleplush = 5,
				   /obj/item/toy/plush/lizardplushie = 5,
				   /obj/item/toy/plush/snakeplushie = 5,
				   /obj/item/toy/plush/slimeplushie = 5,
				   /obj/item/toy/plush/awakenedplushie = 5,
				   /obj/item/toy/plush/beeplushie = 5,
)
	contraband = list(/obj/item/toy/plush/nukeplushie = 5,
				   /obj/item/toy/plush/narplush = 5,
				   /obj/item/toy/plush/plushvar = 5)
	premium = list(/obj/item/toy/plush/goatplushie = 5)
	refill_canister = /obj/item/vending_refill/cigarette
	default_price = 10
	extra_price = 50
	payment_department = ACCOUNT_SRV



/obj/item/vending_refill/citadelplush
	machine_name = "Citadel Plushie"
	icon_state = "refill_custom"
