/obj/machinery/telecomms/server
	var/script

/obj/machinery/telecomms/server/proc/NTSL(datum/signal/sig)
	if (script)
		var/id = lua_run(script, CONFIG_GET(number/lua_timeout), sig.data)
		var/logs = lua_get_logs(id)
		var/vars = lua_get_vars(id)
		for (var/key in vars)
			//log_world("vars\[[key]\] -> sig.data\[[key]\] = [vars[key]]") //debug
			sig.data[key] = vars[key]
		return logs