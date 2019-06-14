#define ELEVATION_HIGH		11
#define ELEVATION_NORMAL	10
#define ELEVATION_KINDALOW	7
#define ELEVATION_LOW		6
#define ELEVATION_SEALEVEL	0

/turf
	var/elevation = ELEVATION_NORMAL
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

/turf/Initialize()
	. = ..()
	check_hippie_icon()

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
	elevation = ELEVATION_HIGH

/turf/open/floor/engine
	elevation = ELEVATION_KINDALOW

/turf/open/floor/plating
	elevation = ELEVATION_LOW

/turf/open/pool
	elevation = ELEVATION_SEALEVEL 
