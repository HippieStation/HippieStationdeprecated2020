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
	reagents_add = list("gold" = 0.2)
	mutatelist = list()
	rarity = 20

/obj/item/grown/log/money
	seed = /obj/item/seeds/tower/moneytree
	name = "money-cap pod"
	icon = 'face/icons/obj/hydroponics/harvest.dmi'
	desc = "It's made of a visicous goo-like substance. Inside you can see some money."
	icon_state = "moneypods"
	plank_type = null
	plank_name = "coins"

/obj/item/grown/log/money/proc/random_coin()
    var/coin = pick(/obj/item/coin/gold,
    /obj/item/coin/diamond,
    /obj/item/coin/uranium,
    /obj/item/coin/iron,
    /obj/item/coin/silver,
    /obj/item/coin/bananium,
    /obj/item/coin/adamantine,
    /obj/item/coin/plasma)
    new coin(get_turf(src))


/obj/item/grown/log/money/attackby(obj/item/W, mob/user, params)
	if(W.sharpness)
		user.show_message("<span class='notice'>You cut the [plank_name] out of \the [src]!</span>", 1)
		playsound(user, 'sound/effects/blobattack.ogg', 50, 1)
		random_coin()
		qdel(src)
	else
		return

/obj/item/grown/log/money/attack_self(mob/living/user)
	user.visible_message("<span class='notice'>[user] crushes [src]'s slimy exterior revealing a coin from within.</span>", "<span class='notice'>You crush [src]'s slimy exterior revealing a coin inside.</span>")
	playsound(user, 'sound/effects/blobattack.ogg', 50, 1)
	random_coin()
	qdel(src)
	return 1