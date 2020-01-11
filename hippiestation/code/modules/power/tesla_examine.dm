/obj/machinery/power/grounding_rod/examine(mob/user)
	. = ..()
	if(anchored)
		. += "It is fastened to the floor."

/obj/machinery/power/tesla_coil/examine(mob/user)
	. = ..()
	if(anchored)
		. += "It is fastened to the floor."
