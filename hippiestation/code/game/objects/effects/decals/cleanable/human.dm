/obj/effect/decal/cleanable/blood/Initialize()
	. = ..()
	if(bloodiness >= 100 && prob(30))
		var/datum/reagent/blood/B = new
		B.handle_state_change(get_turf(src), 6)
		return INITIALIZE_HINT_QDEL