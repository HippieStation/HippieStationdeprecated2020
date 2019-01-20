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
	. = ..()

/turf/Initialize()
    check_hippie_icon()
    return ..()

/turf/examine(mob/user)
	. = ..()
	switch(elevation)
		if(11 to INFINITY)
			to_chat(user, "<span class='notice'>It looks about normal height.</span>")
		if(7 to 10)
			to_chat(user, "<span class='notice'>It looks lower than normal.</span>")
		if(6 to 7)
			to_chat(user, "<span class='notice'>It looks lower than normal.</span>")
		if(0 to 6)
			to_chat(user, "<span class='notice'>Its height seems low.</span>")


/turf/open/floor
	elevation = 11

/turf/open/floor/engine
	elevation = 7

/turf/open/floor/plating
	elevation = 6

/turf/open/pool
	elevation = 0