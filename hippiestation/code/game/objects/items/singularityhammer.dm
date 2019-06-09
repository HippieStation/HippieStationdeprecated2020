/mob/living
	var/worthiness = 0

/obj/item/twohanded/mjollnir
	var/is_returning = FALSE

/obj/item/twohanded/mjollnir/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(L.worthiness)
			L.visible_message("<span class='warning'>[L] catches [src] mid-air!</span>")
			L.put_in_hands(src)
			is_returning = FALSE
			return
	. = ..()
	var/mob/living/retriever
	for(var/mob/living/L in view(7, src))
		if(L.worthiness)
			if(retriever)
				if(L.worthiness > retriever.worthiness)
					retriever = L
			else
				retriever = L
	if(!is_returning && retriever)
		visible_message("<span class='warning'>[src] spins around and begins to fly back at [retriever]!</span>")
		is_returning = TRUE
		throw_at(retriever, 200, 4, spin = TRUE, diagonals_first = TRUE)
	else if(is_returning)
		is_returning = FALSE
