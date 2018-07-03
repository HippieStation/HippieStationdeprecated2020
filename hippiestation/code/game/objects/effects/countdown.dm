/obj/effect/countdown/dominator
	name = "dominator countdown"
	text_size = 1
	color = "#ff00ff" // Overwritten when the dominator starts

/obj/effect/countdown/dominator/get_value()
	var/obj/machinery/dominator/D = attached_to
	if(!istype(D))
		return
	else if(D.gang && D.gang.domination_time != -1)
		return D.gang.domination_time
	else
		return "OFFLINE"