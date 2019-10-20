/obj/effect/portal
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
	layer = 5.2
	var/see_through = TRUE

/obj/effect/portal/Initialize()
	. = ..()
	if(see_through)
		START_PROCESSING(SSfastprocess, src)
		filters += filter(type="alpha", icon = icon('hippiestation/icons/effects/portal.dmi', "portal_mask"))
		update_icon()

/obj/effect/portal/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/portal/process()
	update_icon()

// blame lummox for process() being needed.
/obj/effect/portal/update_icon()
	var/static/list/blacklisted = typecacheof(list(
		/obj/effect/fullbright,
		/atom/movable/lighting_object,
		/obj/machinery/firealarm
	))
	if(see_through)
		vis_contents.Cut()
		if(linked)
			icon = 'hippiestation/icons/effects/portal.dmi'
			var/turf/T = get_turf(linked || hard_target)
			//alpha masks don't affect turfs yet it seems?
			//vis_contents += T
			for(var/atom/A in T)
				if(!is_type_in_typecache(A, blacklisted))
					vis_contents += A

/obj/effect/portal/anom
	see_through = FALSE
