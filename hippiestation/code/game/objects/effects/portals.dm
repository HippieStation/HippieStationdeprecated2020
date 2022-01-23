#if DM_VERSION > 512 && DM_BUILD >= 1506
/obj/effect/portal
	vis_flags = VIS_HIDE
	var/obj/effect/portal_contents/vcontents
	var/see_through = TRUE

/obj/effect/portal/Initialize()
	. = ..()
	if(see_through)
		vcontents = new
		vis_contents += vcontents

/obj/effect/portal/link_portal(obj/effect/portal/newlink)
	. = ..()
	if(see_through)
		if(newlink)
			icon = 'hippiestation/icons/effects/portal.dmi'
			vcontents.vis_contents.Cut()
			newlink.vcontents.vis_contents.Cut()
			vcontents.vis_contents += get_turf(newlink)
			newlink.vcontents.vis_contents += get_turf(src)
			vcontents.setup_filters()
			newlink.vcontents.setup_filters()
		else
			vcontents.vis_contents.Cut()
			vcontents.filters = null
			icon = initial(icon)

/obj/effect/portal/Move(atom/newloc, direct)
	. = ..()
	if(linked)
		icon = 'hippiestation/icons/effects/portal.dmi'
		vcontents.vis_contents.Cut()
		linked.vcontents.vis_contents.Cut()
		vcontents.vis_contents += get_turf(linked)
		linked.vcontents.vis_contents += get_turf(src)
		vcontents.setup_filters()
	else
		vcontents.vis_contents.Cut()
		vcontents.filters = null
		icon = initial(icon)

/obj/effect/portal/anom
	see_through = FALSE

/obj/effect/portal_contents
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/alpha_icon = 'hippiestation/icons/effects/portal.dmi'
	var/alpha_state = "portal_mask"

/obj/effect/portal_contents/proc/setup_filters()
	filters = null
	filters += filter(type="alpha", icon = icon(alpha_icon, alpha_state))
	filters += filter(type="blur", size = 1)
	filters += filter(type="ripple", size = 2, radius = 1, falloff = 1)
	animate(filters[3], time = 2.5 SECONDS, loop = -1, easing = LINEAR_EASING, radius = 16)
#endif
