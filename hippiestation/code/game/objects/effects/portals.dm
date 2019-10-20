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

/obj/effect/portal/update_icon()
	var/static/list/blacklisted = typecacheof(list(
		/obj/effect/fullbright,
		/atom/movable/lighting_object,
		/obj/machinery/firealarm,
		/obj/effect/portal
	))
	if(see_through)
		vis_contents.Cut()
		filters = list()
		if(linked || hard_target)
			icon = 'hippiestation/icons/effects/portal.dmi'
			filters += filter(type="alpha", icon = icon('hippiestation/icons/effects/portal.dmi', "portal_mask"))
			filters += filter(type="blur", size = 1)
			filters += filter(type="ripple", size = 2, radius = current_ripple++, falloff = 1)
			if(current_ripple > 8)
				current_ripple = 0
			var/turf/T = get_turf(linked || hard_target)
			// do not uncomment below until we get VIS_INVISIBLE or something
			//vis_contents += T
			for(var/atom/A in T)
				if(!is_type_in_typecache(A, blacklisted))
					vis_contents += A

/obj/effect/portal/anom
	see_through = FALSE