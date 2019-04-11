/obj/item/assembly/control/activate()
	var/openclose
	if(cooldown)
		return
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if(M.id == src.id)
			if(openclose == null || !sync_doors)
				openclose = M.density
			INVOKE_ASYNC(M, openclose ? /obj/machinery/door/poddoor.proc/open : /obj/machinery/door/poddoor.proc/close)
			cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)
