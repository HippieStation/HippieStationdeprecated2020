/obj/machinery/door/poddoor/shutters/blastco
	resistance_flags = INDESTRUCTIBLE

GLOBAL_LIST(blastco_doors)

/obj/machinery/door/poddoor/shutters/blastco/Initialize()
	. = ..()
	LAZYADD(GLOB.blastco_doors, src)
