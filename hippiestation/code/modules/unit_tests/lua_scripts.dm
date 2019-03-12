/datum/unit_test/lua

/datum/unit_test/lua/Run()
	var/id = call("beyond_the_moon", "run_lua_script")("error('UNIT TEST #1')", "5", "{}")
	if (call("beyond_the_moon", "get_logs")(id) != "SCRIPT ERRORED\n")
		Fail("Erroring Lua script did not error.")

	id = call("beyond_the_moon", "run_lua_script")("log('UNIT TEST #2')", "5", "{}")
	var/log = call("beyond_the_moon", "get_logs")(id)
	if (log != "UNIT TEST #2\n")
		Fail("Lua script did not log properly (Expected \"UNIT TEST #2\", got \"[log]\")")

	id = call("beyond_the_moon", "run_lua_script")("push('unit', 'test #2')", "5", "{}")
	var/vars = json_decode(call("beyond_the_moon", "get_vars")(id))
	if (vars["unit"] != "test #2")
		Fail("Lua script did not push variables properly! (Expected unit=\"test #2\", got \"[vars["unit"]]\".")

	id = call("beyond_the_moon", "run_lua_script")("push('unit', _G.unit)", "5", "{\"unit\": \"test #2\"}")
	var/vars = json_decode(call("beyond_the_moon", "get_vars")(id))
	if (vars["unit"] != "test #2")
		Fail("Lua script did not recieve variables properly! (Expected unit=\"test #2\", got \"[vars["unit"]]\".")