/obj/effect/decal/cleanable/blood/hitsplatter
	name = "blood splatter"
	pass_flags = PASSTABLE | PASSGRILLE
	icon = 'hippiestation/icons/effects/blood.dmi'
	icon_state = "hitsplatter1"
	random_icon_states = list("hitsplatter1", "hitsplatter2", "hitsplatter3")
	var/splattering = FALSE
	var/turf/prev_loc
	var/mob/living/blood_source
	var/skip = FALSE //Skip creation of blood when destroyed?
	var/amount = 3
	plane = -1

/obj/effect/decal/cleanable/blood/hitsplatter/proc/GoTo(turf/T, var/n=rand(1, 3))
	for(var/i in 1 to n)
		if(!src)
			return
		if(splattering)
			return
		prev_loc = loc
		step_towards(src,T)
		if(!src)
			return
		sleep(1)
	if(T.contents.len)
		for(var/obj/item/I in T.contents)
			I.add_mob_blood(blood_source)
	qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Initialize()
	. = ..()
	prev_loc = loc //Just so we are sure prev_loc exists


/obj/effect/decal/cleanable/blood/hitsplatter/Bump(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_mob_blood(blood_source)
	if(istype(A, /turf/closed/wall))
		if(istype(prev_loc)) //var definition already checks for type
			loc = A
			splattering = TRUE //So "Bump()" and "Crossed()" procs aren't called at the same time
			skip = TRUE
			addtimer(CALLBACK(src, .proc/MakeSplatter), 3)
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			loc = A //Either way we got this.
			splattering = TRUE //So "Bump()" and "Crossed()" procs aren't called at the same time
			addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 3)
		return
	qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Crossed(atom/A)
	if(splattering) return
	if(istype(A, /obj/item))
		var/obj/item/I = A
		I.add_mob_blood(blood_source)
		amount--
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.wear_suit)
			H.wear_suit.add_mob_blood(blood_source)
			H.update_inv_wear_suit()    //updates mob overlays to show the new blood (no refresh)
		else if(H.w_uniform)
			H.w_uniform.add_mob_blood(blood_source)
			H.update_inv_w_uniform()    //updates mob overlays to show the new blood (no refresh)
		amount--

	if(istype(A, /turf/closed/wall))
		if(istype(prev_loc)) //var definition already checks for type
			loc = A
			splattering = TRUE //So "Bump()" and "Crossed()" procs aren't called at the same time
			skip = TRUE
			addtimer(CALLBACK(src, .proc/MakeSplatter), 3)
		else //This will only happen if prev_loc is not even a turf, which is highly unlikely.
			loc = A //Either way we got this.
			splattering = TRUE //So "Bump()" and "Crossed()" procs aren't called at the same time
			addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), 3)
		return

	if(amount <= 0)
		qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/proc/MakeSplatter()
	var/mob/living/carbon/human/H = blood_source
	if(istype(H))
		var/obj/effect/decal/cleanable/blood/splatter/B = new(prev_loc)
		//Adjust pixel offset to make splatters appear on the wall
		if(istype(B))
			B.pixel_x = (dir == EAST ? 32 : (dir == WEST ? -32 : 0))
			B.pixel_y = (dir == NORTH ? 32 : (dir == SOUTH ? -32 : 0))
		qdel(src)

/obj/effect/decal/cleanable/blood/hitsplatter/Destroy()
	if(istype(loc, /turf) && !skip)
		loc.add_mob_blood(blood_source)
	return ..()

//Splatter effect END
