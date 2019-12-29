/turf
	var/elevation = 10
	var/pinned = null
#if DM_VERSION > 512
	vis_flags = VIS_INHERIT_PLANE
#endif

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
