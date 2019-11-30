
/obj/machinery/door/airlock/update_icon(state, override)
	. = ..()
	if(operating && !override)
		return
	SSdemo.mark_dirty(src)

/obj/machinery/door/firedoor/update_icon()
	. = ..()
	SSdemo.mark_dirty(src)

/obj/machinery/door/poddoor/update_icon()
	. = ..()
	SSdemo.mark_dirty(src)

/obj/machinery/door/window/update_icon()
	. = ..()
	SSdemo.mark_dirty(src)

/turf/ChangeTurf(path, list/new_baseturfs, flags)
	. = ..()
	SSdemo.mark_turf(src)

/atom/movable/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(.)
		SSdemo.mark_dirty(src)
