/turf
	var/elevation = 10
	var/pinned = null

/turf/Destroy()
	if (pinned)
		var/mob/living/carbon/human/H = pinned

		if (istype(H))
			H.anchored = FALSE
			H.pinned_to = null
			H.do_pindown(src, 0)
			H.update_mobility()

			for (var/obj/item/stack/rods/R in H.contents)
				if (R.pinned)
					R.pinned = null
		pinned = null
	return ..()

/turf/MouseEntered(location, control, params)
	. = ..()
	if(isliving(usr))
		var/mob/living/L = usr
		if(L.client)
			L.client.mouseParams = params
		SEND_SIGNAL(L, COMSIG_MOB_MOUSEENTERED, src, location, control, params)

/turf/MouseExited(location, control, params)
	. = ..()
	if(isliving(usr))
		var/mob/living/L = usr
		if(L.client)
			L.client.mouseParams = params
		SEND_SIGNAL(L, COMSIG_MOB_MOUSEEXITED, src, location, control, params)

/turf/Initialize()
	. = ..()
	check_hippie_icon()
