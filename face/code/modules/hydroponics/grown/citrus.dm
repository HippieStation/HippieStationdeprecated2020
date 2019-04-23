// Cyrogenic Lemon
/obj/item/seeds/lemon
	mutatelist = list(/obj/item/seeds/firelemon, /obj/item/seeds/cryolemon)

/obj/item/seeds/cyrolemon
	name = "pack of cyrogenic lemon seeds"
	desc = "When life gives you lemons, just chill man."
	icon = 'face/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-cyrolemon"
	species = "cyrolemon"
	plantname = "Cyrogenic Lemon Tree"
	product = /obj/item/reagent_containers/food/snacks/grown/cyrolemon
	growing_icon = 'face/icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "lime-grow"
	icon_dead = "lime-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	lifespan = 55
	endurance = 45
	yield = 4
	reagents_add = list("nutriment" = 0.05)

/obj/item/reagent_containers/food/snacks/grown/cyrolemon
	seed = /obj/item/seeds/cyrolemon
	name = "Cyrogenic Lemon"
	desc = "Made for putting out housefires."
	icon = 'face/icons/obj/hydroponics/harvest.dmi'
	icon_state = "cyrolemon"
	bitesize_mod = 2
	foodtype = FRUIT
	wine_power = 70

/obj/item/reagent_containers/food/snacks/grown/cyrolemon/attack_self(mob/living/user)
	user.visible_message("<span class='warning'>[user] primes [src]!</span>", "<span class='userdanger'>You prime [src]!</span>")
	log_bomber(user, "primed a", src, "for detonation")
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.throw_mode_on()
	icon_state = "cyrolemon_active"
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	addtimer(CALLBACK(src, .proc/prime), rand(10, 60))

/obj/item/reagent_containers/food/snacks/grown/cyrolemon/freeze()
	prime()
	..()

/obj/item/reagent_containers/food/snacks/grown/cryolemon/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.dropItemToGround(src)

/obj/item/reagent_containers/food/snacks/grown/cyrolemon/ex_act(severity)
	qdel(src) //Ensuring that it's deleted by its own explosion

/obj/item/reagent_containers/food/snacks/grown/cyrolemon/proc/prime()
	switch(seed.potency) //Combustible lemons are alot like IEDs, lots of flame, very little bang.
		if(0 to 30)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 1)
			qdel(src)
		if(31 to 50)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 2)
			qdel(src)
		if(51 to 70)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 3)
			qdel(src)
		if(71 to 90)
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 4)
			qdel(src)
		else
			update_mob()
			explosion(src.loc,-1,-1,2, flame_range = 5)
			qdel(src)