/obj/item/storage/pod/can_interact(mob/user)
	return TRUE

/obj/machinery/computer/emergency_shuttle
	var/list/last_action = list() // hippie -- kill shuttle auth spam