#define BYONDCRYPT (world.system_type == MS_WINDOWS ? "byond_crypt.dll" : "byond_crypt")
#define BC_STATUS(uuid) call(BYONDCRYPT, "status")(uuid)
#define BC_HASH(data) call(BYONDCRYPT, "bcrypt_hash")(data)
#define BC_VERIFY(data, hash) call(BYONDCRYPT, "bcrypt_verify")(data, hash)
#define BC_ED25519(data, sig, key) call(BYONDCRYPT, "ed25519_verify")(data, sig, key)

/datum/auth_provider/byondcrypt
	id = "dll"
	var/current_pw_id
	var/list/current_ed25519
	var/ed25519_key
	var/hashed_pass

/datum/auth_provider/byondcrypt/AuthStatus(user)
	return list("valid" = istext(get_correct_key(user)))

/datum/auth_provider/byondcrypt/LoginMenu()
	var/output = "<center><p><b>Username: </b><a href='byond://?src=[REF(src)];username=1'>[current_username ? current_username : "Input"]</a></p></center>"
	output += "<p><center>[(current_username && (login_flags & LOGIN_PASSWORD)) ? "<a href='byond://?src=[REF(src)];login=1'>" : ""]Login with Password[(current_username && (login_flags & LOGIN_PASSWORD)) ? "</a>" : ""]</center>"
	output += "<center>[(current_username && (login_flags & LOGIN_ED25519)) ? "<a href='byond://?src=[REF(src)];login=2'>" : ""]Login with Vapor-Auth-Client[(current_username && (login_flags & LOGIN_ED25519)) ? "</a>" : ""]</center>"
	output += "<center>[!CONFIG_GET(flag/guest_ban) ? "<a href='byond://?src=[REF(src)];login=3'>" : ""]Login as Guest[!CONFIG_GET(flag/guest_ban) ? "</a>" : ""]</center></p>"
	return output

/datum/auth_provider/byondcrypt/Topic(href, href_list)
	if(linked_unauth != usr)
		return
	if((current_pw_id && length(current_pw_id)) || LAZYLEN(current_ed25519))
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
		if(!current_username || !length(current_username))
			return
		if(!SSauth.initialized)
			to_chat(linked_unauth, "<span class='danger'>Wait for the Authentication subsystem to initialize!</span>")
			return
		if(logging_in)
			to_chat(linked_unauth, "<span class='danger'>You are already attempting to log in!</span>")
			return
		if(next_login > world.time)
			to_chat(linked_unauth, "<span class='danger'>You must wait [DisplayTimeText(next_login - world.time)] to try to login again!</span>")
			return
		var/val = text2num(href_list["login"])
		if(val == 1 && (login_flags & LOGIN_PASSWORD) && hashed_pass && length(hashed_pass) == 60)
			var/password = input(usr, null, "Password")
			if(password && length(password))
				if(hashed_pass && length(hashed_pass) == 60)
					current_pw_id = BC_VERIFY(password, hashed_pass)
					START_PROCESSING(SSauth, src)
					logging_in = TRUE
					next_login = world.time + AUTH_COOLDOWN
		else if(val == 2 && (login_flags & LOGIN_ED25519) && ed25519_key && length(ed25519_key) == 64)
			var/client_data = list()
			client_data["ckey"] = ckey(current_username)
			client_data["url"] = "byond://localhost:9311"
			current_ed25519 = list()
			for(var/i = 1 to 32)
				LAZYADD(current_ed25519, rand(1, 255))
			client_data["data"] = current_ed25519
			to_chat(linked_unauth, urlbase64(json_encode(client_data)))
			

/datum/auth_provider/byondcrypt/process()
	if(!current_pw_id && !LAZYLEN(current_ed25519))
		return PROCESS_KILL
	if(auth_attempts > MAX_AUTH_ATTEMPTS)
		current_pw_id = null
		current_ed25519 = null
		auth_attempts = 0
		logging_in = FALSE
		return PROCESS_KILL
	else
		if(current_pw_id)
			var/json = BC_STATUS(current_pw_id)
			var/status = json_decode(json)
			if(status["status"] == 2 && status["data"])
				current_pw_id = null
				auth_attempts = 0
				logging_in = FALSE
				if (status["data"] == "yes")
					linked_unauth.login_as(current_username)
				else
					to_chat(linked_unauth, "<span class='danger'>Wrong password!</span>")
				return PROCESS_KILL
		auth_attempts++

/datum/auth_provider/byondcrypt/Setup()
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
	

/datum/auth_provider/byondcrypt/Update()
	if(!current_username || !length(current_username))
		return
	login_flags = NONE
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_logins = SSdbcore.NewQuery({"
			SELECT `password`, HEX(`pubkey`)
			FROM [format_table_name("authentication")]
			WHERE
				ckey = '[sanitizeSQL(ckey(current_username))]'"})
		if(!query_get_logins.Execute())
			qdel(query_get_logins)
			return
		if (query_get_logins.NextRow())
			if(query_get_logins.item[1] && length(query_get_logins.item[1]) == 60)
				login_flags |= LOGIN_PASSWORD
				hashed_pass = query_get_logins.item[1]
			if(query_get_logins.item[2] && length(query_get_logins.item[2]) == 64)
				login_flags |= LOGIN_ED25519
				ed25519_key = query_get_logins.item[2]

/datum/auth_provider/byondcrypt/AuthTopic(list/input)
	if(!((login_flags & LOGIN_ED25519) && LAZYLEN(ed25519_key) == 64))
		return
	if(input["ckey"] != ckey(current_username) || !LAZYLEN(input["data"]))
		return
	var/hexed_data = ""
	var/hexed_sig = ""
	for(var/i in 1 to length(input["data"]))
		hexed_sig = "[hexed_sig][dec2hex(input["data"][i])]"
	for(var/i in 1 to length(current_ed25519))
	if(BC_ED25519(hexed_data, hexed_sig, ed25519_key) == "yes")
		linked_unauth.login_as(current_username)

/proc/dec2hex(n)
    return "[round(n/16)%16>9?ascii2text(round(n/16)%16+55):round(n/16)%16][n%16>9?ascii2text(n%16+55):n%16]"
