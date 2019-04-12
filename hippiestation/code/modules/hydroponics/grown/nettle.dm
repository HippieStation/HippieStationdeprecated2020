/obj/item/seeds/nettle
	mutatelist = list(/obj/item/seeds/nettle/death, /obj/item/seeds/nettle/stun)

/obj/item/seeds/nettle/death
	mutatelist = list(/obj/item/seeds/nettle/stun)
	
/obj/item/seeds/nettle/stun
	name = "pack of stun nettle seeds"
	desc = "These seeds grow into stun nettles."
	icon = 'hippiestation/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-stunnettle"
	species = "stunnettle"
	plantname = "Stun Nettles"
	product = /obj/item/reagent_containers/food/snacks/grown/nettle/stun
	maturation = 8
	yield = 2
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/stinging)
	mutatelist = list(/obj/item/seeds/nettle/death)
	reagents_add = list("tirizene" = 0.2, "tiresolution" = 0.2, "pax" = 0.05, "kelotane" = 0.05)
	rarity = 20
	
/obj/item/reagent_containers/food/snacks/grown/nettle/stun
	seed = /obj/item/seeds/nettle/stun
	name = "stunnettle"
	desc = "It's tiring to even look at"
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	icon_state = "stunnettle"
	lefthand_file = 'hippiestation/icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/weapons/plants_righthand.dmi'
	var/uses = 1

/obj/item/reagent_containers/food/snacks/grown/nettle/stun/Initialize()
	. = ..()
	if(seed)
		uses = round(seed.potency /  33)
	
obj/item/reagent_containers/food/snacks/grown/nettle/stun/afterattack(atom/A as mob|obj, mob/user,proximity)
	. = ..()
	
	if(!proximity)
		return
	
	uses--// When you whack someone with it, leaves fall off
	
	if(uses < 1)
		to_chat(usr, "All the leaves have fallen off the nettle from violent whacking.")
		qdel(src)

