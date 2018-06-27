/obj/effect/countdown/dominator
	name = "dominator countdown"
	text_size = 1
	color = "#ff00ff" // Overwritten when the dominator starts

/obj/effect/countdown/dominator/get_value()
	var/obj/machinery/dominator/D = attached_to
	if(!istype(D))
		return
	else if(D.gang && D.gang.is_dominating)
		var/timer = D.gang.domination_time_remaining()
		return timer
	else
		return "OFFLINE"