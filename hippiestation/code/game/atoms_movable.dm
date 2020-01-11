/obj/item/do_pickup_animation(atom/target)
	return

/atom/movable/Moved(atom/OldLoc, Dir)
	. = ..()
	SSdemo.mark_dirty(src)
