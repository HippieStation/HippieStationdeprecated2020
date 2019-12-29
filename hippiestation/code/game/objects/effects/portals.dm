#if DM_VERSION > 512
/obj/effect/portal
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	vis_flags = VIS_HIDE
	var/see_through = TRUE

/obj/effect/portal/link_portal(obj/effect/portal/newlink)
	. = ..()
	if(see_through)
		if(newlink)
			icon = 'hippiestation/icons/effects/portal.dmi'
			vis_contents.Cut()
			newlink.vis_contents.Cut()
			vis_contents += newlink.loc
			newlink.vis_contents += loc
			setup_filters()
		else
			vis_contents.Cut()
			filters = null
			icon = initial(icon)

/obj/effect/portal/proc/setup_filters()
	filters = null
	filters += filter(type="alpha", icon = icon('hippiestation/icons/effects/portal.dmi', "portal_mask"))
	filters += filter(type="blur", size = 1)
	filters += filter(type="ripple", size = 2, radius = 1, falloff = 1)
	animate(filters[3], time = 1.5 SECONDS, loop = -1, easing = LINEAR_EASING, radius = 8)

/obj/effect/portal/anom
	see_through = FALSE
#endif
