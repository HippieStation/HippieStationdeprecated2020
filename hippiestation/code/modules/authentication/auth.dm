/mob/dead/unauthed/proc/guess_username()
	var/id = md5("[client.address][client.computer_id]")
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_login = SSdbcore.NewQuery({"
			SELECT `key`
			FROM [format_table_name("authentication")]
			WHERE
				last_login = '[sanitizeSQL(id)]'"})
		if(!query_get_login.Execute())
			qdel(query_get_login)
			return
		if (query_get_login.NextRow())
			var/last_login = query_get_login.item[1]
			if(last_login)
				username = last_login
				qdel(query_get_login)
				return
		qdel(query_get_login)

/mob/dead/unauthed/proc/get_correct_key(user)
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_key = SSdbcore.NewQuery({"
			SELECT `key`
			FROM [format_table_name("authentication")]
			WHERE
				ckey = '[sanitizeSQL(ckey(user))]'"})
		if(!query_get_key.Execute())
			qdel(query_get_key)
			return
		if (query_get_key.NextRow())
			var/actual_key = query_get_key.item[1]
			if(actual_key)
				qdel(query_get_key)
				return actual_key
		qdel(query_get_key)

/mob/dead/unauthed/proc/check_password(pass)
	if(!CONFIG_GET(flag/vas_auth) || !CONFIG_GET(string/vas_server) || !length(CONFIG_GET(string/vas_server)))
		return FALSE
	var/data = urlbase64(json_encode(list(ckey = ckey(username), password = pass)))
	var/list/http[] = world.Export("[CONFIG_GET(string/vas_server)]/passauth/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			return (response["ckey"] == ckey(username)) && response["passed"]

/mob/dead/unauthed/proc/check_challenge()
	if(!CONFIG_GET(flag/vas_auth) || !CONFIG_GET(string/vas_server) || !length(CONFIG_GET(string/vas_server)) || !challenge_uuid || !length(challenge_uuid) || !username || !length(username))
		return FALSE
	var/data = urlbase64(json_encode(list(uuid = challenge_uuid)))
	var/list/http[] = world.Export("[CONFIG_GET(string/vas_server)]/authstatus/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			return (response["ckey"] == ckey(username)) && response["passed"]

/mob/dead/unauthed/proc/clear_challenge()
	if(!CONFIG_GET(flag/vas_auth) || !CONFIG_GET(string/vas_server) || !length(CONFIG_GET(string/vas_server)) || !challenge_uuid || !length(challenge_uuid))
		return FALSE
	var/data = urlbase64(json_encode(list(uuid = challenge_uuid)))
	world.Export("[CONFIG_GET(string/vas_server)]/clearchallenge/[data]")
	challenge_uuid = null

/proc/get_auth_status(user)
	if(!CONFIG_GET(flag/vas_auth) || !CONFIG_GET(string/vas_server) || !length(CONFIG_GET(string/vas_server)) || !user || !length(user))
		return FALSE
	var/data = urlbase64(json_encode(list(ckey = ckey(user))))
	var/list/http[] = world.Export("[CONFIG_GET(string/vas_server)]/info/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			return json_decode(file2text(http["CONTENT"]))

/mob/dead/unauthed/proc/update_supported()
	var/list/status = get_auth_status(username)
	if(status)
		supported_login = status["supported"]

/mob/dead/unauthed/proc/setup_challenge()
	if(!CONFIG_GET(flag/vas_auth) || !CONFIG_GET(string/vas_server) || !length(CONFIG_GET(string/vas_server)) || !username || !length(username) || !("challenge" in supported_login))
		return FALSE
	clear_challenge()
	START_PROCESSING(SSauth, src)
	var/data = urlbase64(json_encode(list(ckey = ckey(username))))
	var/list/http[] = world.Export("[CONFIG_GET(string/vas_server)]/beginchallenge/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			if (response["ckey"] == ckey(username))
				challenge_uuid = response["uuid"]
				var/challenge_data = response["data"]
				log_game("Setup challenge [challenge_uuid] for [key]/[ckey(username)]")
				client << link("vaporauth://[urlbase64(json_encode(list(ckey = ckey(username), uuid = challenge_uuid, url = CONFIG_GET(string/vas_server_client), data = challenge_data)))]")
				return TRUE
