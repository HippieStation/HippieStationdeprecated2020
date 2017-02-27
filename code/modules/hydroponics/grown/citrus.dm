// Citrus - base type
/obj/item/weapon/reagent_containers/food/snacks/grown/citrus
	seed = /obj/item/seeds/lime
	name = "citrus"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	bitesize_mod = 2

// Lime
/obj/item/seeds/lime
	name = "pack of lime seeds"
	desc = "These are very sour seeds."
	icon_state = "seed-lime"
	species = "lime"
	plantname = "Lime Tree"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lime
	lifespan = 55
	endurance = 50
	yield = 4
	potency = 15
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/orange)
	reagents_add = list("vitamin" = 0.04, "nutriment" = 0.05)

/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lime
	seed = /obj/item/seeds/lime
	name = "lime"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	filling_color = "#00FF00"

// Orange
/obj/item/seeds/orange
	name = "pack of orange seeds"
	desc = "Sour seeds."
	icon_state = "seed-orange"
	species = "orange"
	plantname = "Orange Tree"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange
	lifespan = 60
	endurance = 50
	yield = 5
	potency = 20
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/lime)
	reagents_add = list("vitamin" = 0.04, "nutriment" = 0.05)

/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/orange
	seed = /obj/item/seeds/orange
	name = "orange"
	desc = "It's an tangy fruit."
	icon_state = "orange"
	filling_color = "#FFA500"

// Lemon
/obj/item/seeds/lemon
	name = "pack of lemon seeds"
	desc = "These are sour seeds."
	icon_state = "seed-lemon"
	species = "lemon"
	plantname = "Lemon Tree"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lemon
	lifespan = 55
	endurance = 45
	yield = 4
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/firelemon)
	reagents_add = list("vitamin" = 0.04, "nutriment" = 0.05)

/obj/item/weapon/reagent_containers/food/snacks/grown/citrus/lemon
	seed = /obj/item/seeds/lemon
	name = "lemon"
	desc = "When life gives you lemons, make lemonade."
	icon_state = "lemon"
	filling_color = "#FFD700"

// Combustible lemon
/obj/item/seeds/firelemon //combustible lemon is too long so firelemon
	name = "pack of combustible lemon seeds"
	desc = "When life gives you lemons, don't make lemonade. Make life take the lemons back! Get mad! I don't want your damn lemons!"
	icon_state = "seed-firelemon"
	species = "firelemon"
	plantname = "Combustible Lemon Tree"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/firelemon
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 55
	endurance = 45
	yield = 4
	reagents_add = list("nutriment" = 0.05)

/obj/item/weapon/reagent_containers/food/snacks/grown/firelemon
	seed = /obj/item/seeds/firelemon
	name = "Combustible Lemon"
	desc = "Made for burning houses down."
	icon_state = "firelemon"
	bitesize_mod = 2
	var/isprimed = FALSE

/obj/item/weapon/reagent_containers/food/snacks/grown/firelemon/attack_self(mob/living/user)
	if(isprimed)
		return
	var/area/A = get_area(user)
	user.visible_message("<span class='warning'>[user] squeezes the [src]!</span>", "<span class='userdanger'>You squeeze the [src]!</span>")
	var/message = "[ADMIN_LOOKUPFLW(user)] primed a combustible lemon for detonation at [A] [ADMIN_COORDJMP(user)]"
	bombers += message
	message_admins(message)
	log_game("[key_name(user)] primed a combustible lemon for detonation at [A] [COORD(user)].")
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.throw_mode_on()
	icon_state = "firelemon_active"
	isprimed = TRUE
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	addtimer(CALLBACK(src, .proc/prime), rand(10, 60))

/obj/item/weapon/reagent_containers/food/snacks/grown/firelemon/burn()
	isprimed = TRUE
	prime()
	..()

/obj/item/weapon/reagent_containers/food/snacks/grown/firelemon/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.dropItemToGround(src)

/obj/item/weapon/reagent_containers/food/snacks/grown/firelemon/ex_act(severity)
	qdel(src) //Ensuring that it's deleted by its own explosion

/obj/item/weapon/reagent_containers/food/snacks/grown/firelemon/proc/prime()
	switch(seed.potency) //Explosion size is proportional to potency.
		if(0 to 20)
			update_mob()
			explosion(src.loc,-1,-1,1, flame_range = -1)
			qdel(src)
		if(21 to 40)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 1)
			qdel(src)
		if(41 to 60)
			update_mob()
			explosion(src.loc,-1,-1,3, flame_range = 2)
			qdel(src)
		if(61 to 80)
			update_mob()
			explosion(src.loc,-1,1,3, flame_range = 2)
			qdel(src)
		if(80 to 100)
			update_mob()
			explosion(src.loc,-1,1,5, flame_range = 3)
			qdel(src)
