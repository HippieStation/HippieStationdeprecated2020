#if DM_VERSION > 512 && DM_BUILD >= 1506
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
			vis_contents += get_turf(newlink)
			newlink.vis_contents += get_turf(src)
			setup_filters()
		else
			vis_contents.Cut()
			filters = null
			icon = initial(icon)

/obj/effect/portal/Move(atom/newloc, direct)
	. = ..()
	if(linked)
		icon = 'hippiestation/icons/effects/portal.dmi'
		vis_contents.Cut()
		linked.vis_contents.Cut()
		vis_contents += get_turf(linked)
		linked.vis_contents += get_turf(src)
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
