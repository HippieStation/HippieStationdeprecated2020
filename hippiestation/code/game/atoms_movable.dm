/obj/item/do_pickup_animation(atom/target)
	return

/mob/living/carbon/Moved(atom/OldLoc, Dir, Forced = FALSE)
	..()
	if(OldLoc)
		for(var/obj/O in get_turf(src))
			if(istype(O, /obj/effect/liquid))
				O.Crossed(src, OldLoc) 