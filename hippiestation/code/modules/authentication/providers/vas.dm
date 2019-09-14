/datum/auth_provider/vaporauth
	id = "vas"
	var/challenge_uuid

/datum/auth_provider/vaporauth/Topic(href, href_list)
	if(linked_unauth != usr)
		return
	if(challenge_uuid)
		to_chat(linked_unauth, "<span class='danger'>You are already attempting to log in!</span>")
		return
	if(href_list["username"])
		var/new_username = input(usr, null, "Username")
		if(new_username && length(new_username))
			var/corrected = get_correct_key(new_username)
			if(corrected)
				current_username = corrected
				Update()
				linked_unauth.login_panel()
	if(href_list["login"])
		if(!SSauth.initialized)
			to_chat(linked_unauth, "<span class='danger'>Wait for the Authentication subsystem to initialize!</span>")
			return
		if(!current_username || !length(current_username))
			return
		if(logging_in)
			to_chat(linked_unauth, "<span class='danger'>You are already attempting to log in!</span>")
			return
		if(next_login > world.time)
			to_chat(linked_unauth, "<span class='danger'>You must wait [DisplayTimeText(next_login - world.time)] to try to login again!</span>")
			return
		var/val = text2num(href_list["login"])
		if(val == 1 && (login_flags & LOGIN_PASSWORD))
			var/password = input(usr, null, "Password")
			logging_in = TRUE
			if(password && length(password) && check_password(password))
				linked_unauth.login_as(current_username)
				return
			else
				to_chat(linked_unauth, "<span class='danger'>Wrong password!</span>")
			logging_in = FALSE
			next_login = world.time + AUTH_COOLDOWN
		else if(val == 2 && (login_flags & LOGIN_ED25519))
			logging_in = TRUE
			if(!setup_challenge())
				logging_in = FALSE
			next_login = world.time + AUTH_COOLDOWN

/datum/auth_provider/vaporauth/process()
	if(auth_attempts > MAX_AUTH_ATTEMPTS)
		clear_challenge()
		return PROCESS_KILL
	if(challenge_uuid && length(challenge_uuid))
		if(check_challenge())
			log_game("[linked_unauth.key]/[current_username] passed [challenge_uuid]")
			clear_challenge()
			linked_unauth.login_as(current_username)
			return PROCESS_KILL
		else
			auth_attempts++

/datum/auth_provider/vaporauth/LoginMenu()
	var/output = "<center><p><b>Username: </b><a href='byond://?src=[REF(src)];username=1'>[current_username ? current_username : "Input"]</a></p></center>"
	output += "<p><center>[(current_username && (login_flags & LOGIN_PASSWORD)) ? "<a href='byond://?src=[REF(src)];login=1'>" : ""]Login with Password[(current_username && (login_flags & LOGIN_PASSWORD)) ? "</a>" : ""]</center>"
	output += "<center>[(current_username && (login_flags & LOGIN_ED25519) && config["client"] && length(config["client"])) ? "<a href='byond://?src=[REF(src)];login=2'>" : ""]Login with Vapor-Auth-Client[(current_username && (login_flags & LOGIN_ED25519) && config["client"] && length(config["client"])) ? "</a>" : ""]</center>"
	output += "<center>[!CONFIG_GET(flag/guest_ban) ? "<a href='byond://?src=[REF(src)];login=3'>" : ""]Login as Guest[!CONFIG_GET(flag/guest_ban) ? "</a>" : ""]</center></p>"
	return output

/datum/auth_provider/vaporauth/AuthStatus(user)
	if(!config["server"] || !length(config["server"]) || !user || !length(user))
		return FALSE
	var/data = urlbase64(json_encode(list(ckey = ckey(user))))
	var/list/http[] = world.Export("[config["server"]]/info/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			return json_decode(file2text(http["CONTENT"]))

/datum/auth_provider/vaporauth/Setup()
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_key = SSdbcore.NewQuery({"
			SELECT `key`
			FROM [format_table_name("authentication")]
			WHERE
				last_login = '[sanitizeSQL(md5("[linked_unauth.client.address][linked_unauth.client.computer_id]"))]'"})
		if(!query_get_key.Execute())
			qdel(query_get_key)
			return
		if (query_get_key.NextRow())
			if(query_get_key.item[1] && length(query_get_key.item[1]))
				current_username = query_get_key.item[1]
		qdel(query_get_key)
	Update()

/datum/auth_provider/vaporauth/Update()
	if(!current_username || !length(current_username))
		return
	login_flags = NONE
	var/list/status = AuthStatus(current_username)
	if(LAZYLEN(status["supported"]))
		if("password" in status["supported"])
			login_flags |= LOGIN_PASSWORD
		if("challenge" in status["supported"])
			login_flags |= LOGIN_ED25519

/datum/auth_provider/vaporauth/proc/check_password(pass)
	if(!config["server"] || !length(config["server"]))
		return FALSE
	var/data = urlbase64(json_encode(list(ckey = ckey(current_username), password = pass)))
	var/list/http[] = world.Export("[config["server"]]/passauth/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			return (response["ckey"] == ckey(current_username)) && response["passed"]

/datum/auth_provider/vaporauth/proc/check_challenge()
	if(!config["server"] || !challenge_uuid || !current_username || !length(current_username))
		return FALSE
	var/data = urlbase64(json_encode(list(uuid = challenge_uuid)))
	var/list/http[] = world.Export("[config["server"]]/authstatus/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			return (response["ckey"] == ckey(current_username)) && response["passed"]

/datum/auth_provider/vaporauth/proc/clear_challenge()
	if(!config["server"] || !challenge_uuid)
		return FALSE
	var/data = urlbase64(json_encode(list(uuid = challenge_uuid)))
	world.Export("[config["server"]]/clearchallenge/[data]")
	challenge_uuid = null
	auth_attempts = 0
	logging_in = FALSE

/datum/auth_provider/vaporauth/proc/setup_challenge()
	if(!config["server"] || !config["client"] || !current_username || !length(current_username) || !(login_flags & LOGIN_ED25519))
		return FALSE
	clear_challenge()
	START_PROCESSING(SSauth, src)
	var/data = urlbase64(json_encode(list(ckey = ckey(current_username))))
	var/list/http[] = world.Export("[config["server"]]/beginchallenge/[data]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			if (response["ckey"] == ckey(current_username))
				challenge_uuid = response["uuid"]
				var/challenge_data = response["data"]
				log_game("Setup challenge [challenge_uuid] for [linked_unauth.key]/[ckey(current_username)]")
				linked_unauth.client << link("vaporauth://[urlbase64(json_encode(list(ckey = ckey(current_username), uuid = challenge_uuid, url = config["client"], data = challenge_data)))]")
				return TRUE
