/proc/lua_run(script, timeout, vars)
	var/id = call("beyond_the_moon", "run_lua_script")(script, "[timeout]", json_encode(vars))
	return id

/proc/lua_get_logs(id)
	return call("beyond_the_moon", "get_logs")(id)

/proc/lua_get_vars(id)
	return json_decode(call("beyond_the_moon", "get_vars")("[id]"))
