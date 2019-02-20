/obj/machinery/door/poddoor/open(ignorepower = 0)
	. = ..()
	playsound(loc, 'hippiestation/sound/machines/blast_door.ogg', 100, 1)

/obj/machinery/door/poddoor/close(ignorepower = 0)
	. = ..()
	playsound(loc, 'hippiestation/sound/machines/blast_door.ogg', 100, 1)

/obj/machinery/door/poddoor/preopen/biohazard
	name = "biohazard blast door"
	icon = 'hippiestation/icons/obj/doors/hazarddoor.dmi'