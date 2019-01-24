/obj/effect/decal/cleanable/blood
	plane = -1

/obj/effect/decal/cleanable/blood/hitsplatter
	name = "blood splatter"
	pass_flags = PASSTABLE | PASSGRILLE
	icon = 'hippiestation/icons/effects/blood.dmi'
	icon_state = "hitsplatter1"
	random_icon_states = list("hitsplatter1", "hitsplatter2", "hitsplatter3")
	var/turf/prev_loc
	var/mob/living/blood_source
	var/skip = FALSE //Skip creation of blood when destroyed?
	var/amount = 3

/obj/effect/decal/cleanable/blood/hitsplatter/Initialize()
	. = ..()
	prev_loc = loc //Just so we are sure prev_loc exists

/obj/effect/decal/cleanable/blood/hitsplatter/proc/GoTo(turf/T, var/range)
	for(var/i in 1 to range)
		step_towards(src,T)
		sleep(2)
		prev_loc = loc
		for(var/atom/A in get_turf(src))
			if(amount <= 0)
				break
			if(istype(A,/obj/item))
				var/obj/item/I = A
				I.add_mob_blood(blood_source)
				amount--
			if(istype(A, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = A
				if(H.wear_suit)
					H.wear_suit.add_mob_blood(blood_source)
					H.update_inv_wear_suit()    //updates mob overlays to show the new blood (no refresh)
				if(H.w_uniform)
					H.w_uniform.add_mob_blood(blood_source)
					H.update_inv_w_uniform()    //updates mob overlays to show the new blood (no refresh)
				amount--
		if(amount <= 0) // we used all the puff so we delete it.
			qdel(src)
			return
	qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Bump(atom/A)
	if(istype(A, /turf/closed/wall))
		if(istype(prev_loc)) //var definition already checks for type
			loc = A
			skip = TRUE
			var/mob/living/carbon/human/H = blood_source
			if(istype(H))
				var/obj/effect/decal/cleanable/blood/splatter/B = new(prev_loc)
				//Adjust pixel offset to make splatters appear on the wall
				if(istype(B))
					B.pixel_x = (dir == EAST ? 32 : (dir == WEST ? -32 : 0))
					B.pixel_y = (dir == NORTH ? 32 : (dir == SOUTH ? -32 : 0))
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			loc = A //Either way we got this.
			addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 3)
		return
	qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Destroy()
	if(istype(loc, /turf) && !skip)
		loc.add_mob_blood(blood_source)
	return ..()

//Splatter effect END
