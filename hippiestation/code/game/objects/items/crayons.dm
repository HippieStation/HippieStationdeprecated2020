/obj/item/toy/crayon
	var/gang = FALSE //For marking territory

/obj/item/toy/crayon/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !check_allowed_items(target))
		return

	var/cost = 1
	if(paint_mode == PAINT_LARGE_HORIZONTAL)
		cost = 5
	if(istype(target, /obj/item/canvas))
		cost = 0
	var/charges_used = use_charges(user, cost)
	if(!charges_used)
		return
	. = charges_used

	if(istype(target, /obj/effect/decal/cleanable))
		target = target.loc

	if(!is_type_in_list(target,validSurfaces))
		return

	var/drawing = drawtype
	switch(drawtype)
		if(RANDOM_LETTER)
			drawing = pick(letters)
		if(RANDOM_GRAFFITI)
			drawing = pick(graffiti)
		if(RANDOM_RUNE)
			drawing = pick(runes)
		if(RANDOM_ORIENTED)
			drawing = pick(oriented)
		if(RANDOM_NUMBER)
			drawing = pick(numerals)
		if(RANDOM_ANY)
			drawing = pick(all_drawables)

	var/temp = "rune"
	if(drawing in letters)
		temp = "letter"
	else if(drawing in graffiti)
		temp = "graffiti"
	else if(drawing in numerals)
		temp = "number"

	// If a gang member is using a gang spraycan, it'll behave differently
	var/gang_mode = FALSE
	if(gang && user.mind && user.mind.gang_datum)
		gang_mode = TRUE

	// discontinue if the area isn't valid for tagging because gang "honour"
	if(gang_mode && (!can_claim_for_gang(user, target)))
		return

	var/graf_rot
	if(drawing in oriented)
		switch(user.dir)
			if(EAST)
				graf_rot = 90
			if(SOUTH)
				graf_rot = 180
			if(WEST)
				graf_rot = 270
			else
				graf_rot = 0

	var/list/click_params = params2list(params)
	var/clickx
	var/clicky

	if(click_params && click_params["icon-x"] && click_params["icon-y"])
		clickx = CLAMP(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
		clicky = CLAMP(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)

	if(!instant)
		to_chat(user, "<span class='notice'>You start drawing a [temp] on the	[target.name]...</span>")

	if(pre_noise)
		audible_message("<span class='notice'>You hear spraying.</span>")
		playsound(user.loc, 'sound/effects/spray.ogg', 5, 1, 5)

	var/takes_time = !instant

	if(gang_mode)
		takes_time = TRUE

	var/wait_time = 50
	if(PAINT_LARGE_HORIZONTAL)
		wait_time *= 3

	if(takes_time)
		if(!do_after(user, 50, target = target))
			return

	if(length(text_buffer))
		drawing = copytext(text_buffer,1,2)


	var/list/turf/affected_turfs = list()

	if(actually_paints)
		if(gang_mode)
			// Double check it wasn't tagged in the meanwhile
			if(!can_claim_for_gang(user, target))
				return
			tag_for_gang(user, target)
			affected_turfs += target
		else
			switch(paint_mode)
				if(PAINT_NORMAL)
					var/obj/effect/decal/cleanable/crayon/C = new(target, paint_color, drawing, temp, graf_rot)
					C.add_hiddenprint(user)
					C.pixel_x = clickx
					C.pixel_y = clicky
					affected_turfs += target
				if(PAINT_LARGE_HORIZONTAL)
					var/turf/left = locate(target.x-1,target.y,target.z)
					var/turf/right = locate(target.x+1,target.y,target.z)
					if(is_type_in_list(left, validSurfaces) && is_type_in_list(right, validSurfaces))
						var/obj/effect/decal/cleanable/crayon/C = new(left, paint_color, drawing, temp, graf_rot, PAINT_LARGE_HORIZONTAL_ICON)
						C.add_hiddenprint(user)
						affected_turfs += left
						affected_turfs += right
						affected_turfs += target
					else
						to_chat(user, "<span class='warning'>There isn't enough space to paint!</span>")
						return

	if(!instant)
		to_chat(user, "<span class='notice'>You finish drawing \the [temp].</span>")
	else
		to_chat(user, "<span class='notice'>You spray a [temp] on \the [target.name]</span>")

	if(length(text_buffer))
		text_buffer = copytext(text_buffer,2)

	if(post_noise)
		audible_message("<span class='notice'>You hear spraying.</span>")
		playsound(user.loc, 'sound/effects/spray.ogg', 5, 1, 5)

	var/fraction = min(1, . / reagents.maximum_volume)
	if(affected_turfs.len)
		fraction /= affected_turfs.len
	for(var/t in affected_turfs)
		reagents.reaction(t, TOUCH, fraction * volume_multiplier)
		reagents.trans_to(t, ., volume_multiplier)
	check_empty(user)

/obj/item/toy/crayon/proc/can_claim_for_gang(mob/user, atom/target)
	// Check area validity.
	// Reject space, player-created areas, and non-station z-levels.
	var/area/A = get_area(target)
	if(!A || (A.z != ZLEVEL_STATION_PRIMARY) || !A.valid_territory)
		to_chat(user, "<span class='warning'>[A] is unsuitable for tagging.</span>")
		return FALSE

	var/spraying_over = FALSE
	for(var/obj/effect/decal/cleanable/crayon/gang/G in target)
		spraying_over = TRUE

	for(var/obj/machinery/power/apc in target)
		to_chat(user, "<span class='warning'>You can't tag an APC.</span>")
		return FALSE

	var/occupying_gang = territory_claimed(A, user)
	if(occupying_gang && !spraying_over)
		to_chat(user, "<span class='danger'>[A] has already been tagged by the [occupying_gang] gang! You must get rid of or spray over the old tag first!</span>")
		return FALSE

	// If you pass the gaunlet of checks, you're good to proceed
	return TRUE

/obj/item/toy/crayon/proc/territory_claimed(area/territory, mob/user)
	for(var/datum/gang/G in SSticker.mode.gangs)
		if(territory.type in (G.territory|G.territory_new))
			. = G.name
			break

/obj/item/toy/crayon/proc/tag_for_gang(mob/user, atom/target)
	//Delete any old markings on this tile, including other gang tags
	for(var/obj/effect/decal/cleanable/crayon/old_marking in target)
		qdel(old_marking)

	var/gangID = user.mind.gang_datum
	var/area/territory = get_area(target)

	new /obj/effect/decal/cleanable/crayon/gang(target,gangID,"graffiti",0,user)
	to_chat(user, "<span class='notice'>You tagged [territory] for your gang!</span>")

/obj/item/toy/crayon/spraycan/gang
	//desc = "A modified container containing suspicious paint."
	charges = 20
	gang = TRUE

	pre_noise = FALSE
	post_noise = TRUE

/obj/item/toy/crayon/spraycan/gang/New(loc, datum/gang/G)
	..()
	if(G)
		paint_color = G.color_hex
		update_icon()

/obj/item/toy/crayon/spraycan/gang/examine(mob/user)
	. = ..()
	if((user.mind && user.mind.gang_datum) || isobserver(user))
		to_chat(user, "This spraycan has been specially modified for tagging territory.")