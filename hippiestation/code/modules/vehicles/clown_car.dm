/obj/vehicle/sealed/car/clowncar/roundstart
	icon = 'hippiestation/icons/obj/vehicles.dmi'
	desc = "The funnest way to travel the station"
	car_traits = NONE
	armor = list("melee" = 40, "bullet" = 20, "laser" = 20, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 80)


/obj/vehicle/sealed/car/clowncar/roundstart/mob_try_exit(mob/M, mob/user, silent = FALSE)
	if(M == user && (occupants[M] & VEHICLE_CONTROL_KIDNAPPED))
		to_chat(user, "<span class='notice'>You get out of [src].</span>")
		mob_exit(M, silent)
		return TRUE