/obj/machinery/atmospherics/components/binary/volume_pump/CtrlClick(mob/user)
	if(is_ganymede(user))
		to_chat(user, "<span class='danger'>\The [src] is too small for your big hands to adjust!</span>")
		return
	return ..()

/obj/machinery/atmospherics/components/binary/volume_pump/AltClick(mob/user)
	if(is_ganymede(user))
		to_chat(user, "<span class='danger'>\The [src] is too small for your big hands to adjust!</span>")
		return
	return ..()

/obj/machinery/atmospherics/components/binary/volume_pump/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
																		datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	if(is_ganymede(user))
		to_chat(user, "<span class='danger'>\The [src] is too small for your big hands to adjust!</span>")
		return
	return ..()
