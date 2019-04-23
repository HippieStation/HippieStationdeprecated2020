/obj/item/seeds/tower
	mutatelist = list(/obj/item/seeds/tower/steel, /obj/item/seeds/tower/moneytree)

/obj/item/seeds/tower/steel
	mutatelist = list(/obj/item/seeds/tower/moneytree)

/obj/item/seeds/tower/moneytree
	name = "pack of money-cap mycelium"
	desc = "This mycelium grows into bushels of money?!."
	icon = 'face/icons/obj/hydroponics/seeds.dmi'
	icon_state = "mycelium-moneycap"
	species = "moneycap"
	plantname = "Money Caps"
	growing_icon = 'face/icons/obj/hydroponics/growing_mushrooms.dmi'
	icon_dead = "moneycap-dead"
	product = /obj/item/grown/log/money
	mutatelist = list()
	rarity = 20

/obj/item/grown/log/money
	seed = /obj/item/seeds/tower/moneytree
	name = "money-cap pod"
	icon = 'face/icons/obj/hydroponics/harvest.dmi'
	desc = "It's made of a visicous goo-like substance. Inside you can see some money."
	icon_state = "moneypods"
	plank_type = /obj/item/coin/gold
	plank_name = "gold coins"

/obj/item/grown/log/money/attackby(obj/item/W, mob/user, params)
	if(W.sharpness)
		user.show_message("<span class='notice'>You cut the [plank_name] out of \the [src]!</span>", 1)
		var/seed_modifier = 0
		if(seed)
			seed_modifier = round(seed.potency / 25)
		new plank_type(user.loc, rand(1,3) + seed_modifier)
		qdel(src)