/obj/item/seeds/tower
	mutatelist = list(/obj/item/seeds/tower/steel, /obj/item/seeds/tower/moneytree)

/obj/item/seeds/tower/steel
	mutatelist = list(/obj/item/seeds/tower/moneytree)

/obj/item/seeds/tower/moneytree
	name = "pack of money-cap mycelium"
	desc = "This mycelium grows into bushels of money?!."
	icon_state = "mycelium-moneycap"
	species = "moneycap"
	plantname = "Money Caps"
	growing_icon = 'face/icons/obj/hydroponics/growing_mushrooms.dmi'
	icon_dead = "moneycap-dead"
	product = /obj/item/grown/log/steel/money
	mutatelist = list()
	rarity = 20

/obj/item/grown/log/steel/money
	seed = /obj/item/seeds/tower/moneytree
	name = "money-cap pod"
	desc = "It's made of a visicous goo-like substance. Inside you can see some money."
	icon_state = "moneypods"
	plank_type = /obj/item/coin/gold
	plank_name = "gold coins"

/obj/item/grown/log/steel/money/CheckAccepted(obj/item/I)
	return FALSE