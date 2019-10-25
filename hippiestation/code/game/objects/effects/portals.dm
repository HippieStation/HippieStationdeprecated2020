/obj/effect/portal
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	layer = 5.2
	var/see_through = TRUE
	var/current_ripple = 0

/obj/effect/portal/Initialize()
	. = ..()
	if(see_through)
		START_PROCESSING(SSfastprocess, src)
		update_icon()

/obj/effect/portal/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/portal/process()
	update_icon()

/obj/effect/portal/link_portal(obj/effect/portal/newlink)
	. = ..()
	vis_contents.Cut()
	newlink.vis_contents.Cut()
	vis_contents += newlink.loc
	newlink.vis_contents += loc

/obj/effect/portal/update_icon()
	if(linked || hard_target)
		icon = 'hippiestation/icons/effects/portal.dmi'
		filters += filter(type="alpha", icon = icon('hippiestation/icons/effects/portal.dmi', "portal_mask"))
		filters += filter(type="blur", size = 1)
		filters += filter(type="ripple", size = 2, radius = current_ripple++, falloff = 1)
		if(current_ripple > 8)
			current_ripple = 0

/obj/effect/portal/anom
	see_through = FALSE
