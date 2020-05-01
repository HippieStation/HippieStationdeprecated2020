/mob/living
	var/worthiness = 0

/obj/item/twohanded/mjollnir
	icon = 'hippiestation/icons/obj/items_and_weapons.dmi'
	lefthand_file = 'hippiestation/icons/mob/inhands/lefthand.dmi'
	righthand_file = 'hippiestation/icons/mob/inhands/righthand.dmi'
	icon_state = "mjollnir"
	item_state = "mjollnir0"
	var/is_returning = FALSE

/obj/item/twohanded/mjollnir/update_icon()  //Currently only here to fuck with the on-mob icons.
	item_state = "mjollnir[wielded]"
	return

/obj/item/twohanded/mjollnir/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE, quickstart = TRUE)
	if(iscarbon(thrower))
		var/mob/living/carbon/C = thrower
		C.throw_mode_on() //so they can catch it on the return.
	return ..()

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
		sleep(1)
		throw_at(retriever, throw_range+2, throw_speed, null, TRUE, TRUE)
	else if(is_returning)
		is_returning = FALSE
