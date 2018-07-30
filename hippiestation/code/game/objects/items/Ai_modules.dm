/obj/item/aiModule
	var/damaged = FALSE

/obj/item/aiModule/core/full/damaged
	damaged = TRUE

/obj/item/aiModule/attackby(obj/item/W, mob/user, params)	//Cause I want to make meme laws without needing to go to space >:(
	..()
	if(istype(W, /obj/item/screwdriver))
		if(damaged)
			to_chat(user, "<span class='warning'>If you damage the board any more it will be completely unusable!</span>")
			return
		else
			to_chat(user, "<span class='warning'>You violently smash the screwdriver into the [src]'s circuit pieces and damage the board!</span>")
			var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread
			sp.set_up(5, 1, src)
			sp.start()
			qdel(src)
			user.put_in_hands(new /obj/item/aiModule/core/full/damaged(user.loc))
