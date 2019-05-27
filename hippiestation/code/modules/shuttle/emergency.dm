/obj/item/storage/pod/can_interact(mob/user)
	return TRUE

/obj/machinery/computer/emergency_shuttle
	var/list/last_action = list() // hippie -- kill shuttle auth spam
	
/obj/docking_port/mobile/emergency/request(obj/docking_port/stationary/S, area/signalOrigin, reason, redAlert, set_coefficient=null)
	reason = copytext(reason, 1, 100)
	return ..(S, signalOrigin, reason, redAlert, set_coefficient)
