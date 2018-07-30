/obj/item/reagent_containers/food/drinks/throw_impact(atom/target, datum/thrownthing/throwinfo)
	. = ..()
	if(!. && throwinfo) //if the bottle wasn't caught & throwinfo exists
		smash(target, throwinfo.thrower, TRUE)