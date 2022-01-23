// returns 3-letter mode string, used by status screens and mob status panel
/obj/docking_port/mobile/proc/getModeStr()
	switch(mode)
		if(SHUTTLE_IGNITING)
			return "IGN"
		if(SHUTTLE_RECALL)
			return "RCL"
		if(SHUTTLE_CALL)
			return "ETA"
		if(SHUTTLE_DOCKED)
			return "ETD"
		if(SHUTTLE_ESCAPE)
			return "ESC"
		if(SHUTTLE_STRANDED)
			return "ERR"
		if(SHUTTLE_RECHARGING)
			return "RCH"
		if(SHUTTLE_PREARRIVAL)
			return "LDN"
		if(SHUTTLE_DISABLED)
			return "DIS"
	return ""

// returns 5-letter timer string, used by status screens and mob status panel
/obj/docking_port/mobile/proc/getTimerStr()
	if(mode == SHUTTLE_STRANDED)
		return "--:--"

	if(mode == SHUTTLE_DISABLED)
		return "--:--"

	var/timeleft = timeLeft()
	if(timeleft > 1 HOURS)
		return "--:--"
	else if(timeleft > 0)
		return "[add_leading(num2text((timeleft / 60) % 60),2,"0")]:[add_leading(num2text(timeleft % 60), 2, "0")]"
	else
		return "00:00"
