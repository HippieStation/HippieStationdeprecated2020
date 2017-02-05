/obj/item/seeds/buttseed
	name = "pack of replica butt seeds"
	desc = "Replica butts...has science gone too far?"
	icon_state = "seed-butt"
	species = "butt"
	plantname = "Replica Butt Flower"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/buttflower
	lifespan = 25
	endurance = 10
	maturation = 8
	production = 6
	yield = 1
	growing_icon = 'icons/obj/hydroponics/growing_flowers.dmi'
	potency = 20
	growthstages = 3
	reagents_add = list("fartium" = 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/buttflower
	seed = /obj/item/seeds/buttseed
	name = "buttflower"
	desc = "Gives off a pungent aroma once it blooms."
	icon_state = "buttflower" //coder spriting ftw
	trash = /obj/item/organ/internal/butt
