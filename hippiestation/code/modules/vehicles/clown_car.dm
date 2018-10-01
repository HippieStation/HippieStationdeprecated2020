/obj/vehicle/sealed/car/clowncar/roundstart
	icon = 'hippiestation/icons/obj/vehicles.dmi'
	desc = "The funnest way to travel the station"
	car_traits = NONE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 20, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)
	movedelay = 0.8


/obj/vehicle/sealed/car/clowncar/roundstart/mob_try_exit(mob/M, mob/user, silent = FALSE)
	if(M == user && (occupants[M] & VEHICLE_CONTROL_KIDNAPPED))
		to_chat(user, "<span class='notice'>You get out of [src].</span>")
		mob_exit(M, silent)
		return TRUE
	else
		..()

/obj/vehicle/sealed/car/clowncar/roundstart/DumpMobs(randomstep = FALSE)//So people are not stunned on exiting the clowncar
	for(var/i in occupants)
		if(iscarbon(i))
			if(is_driver(i))
				var/mob/living/carbon/C = i
				C.Knockdown(40)
			mob_exit(i)

/obj/vehicle/sealed/car/clowncar/roundstart/DumpSpecificMobs(flag, randomstep = FALSE)
	for(var/i in occupants)
		if((occupants[i] & flag))
			var/mob/living/carbon/C = i
			mob_exit(C)