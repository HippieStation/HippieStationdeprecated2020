/obj/machinery/stasis/Initialize(mapload)
	. = ..()
	if(mapload)
		var/obj/machinery/sleeper/S = new(loc, mapload)
		S.setDir(dir)
		return INITIALIZE_HINT_QDEL
