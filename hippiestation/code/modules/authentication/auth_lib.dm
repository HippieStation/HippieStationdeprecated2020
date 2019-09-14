#define MAX_ATTEMPTS	3
#define LOGIN_COOLDOWN	3 SECONDS

#define BYONDCRYPT (world.system_type == MS_WINDOWS ? "byond_crypt.dll" : "byond_crypt")
#define BC_STATUS(uuid) call(BYONDCRYPT, "status")(uuid)
#define BC_HASH(data) call(BYONDCRYPT, "bcrypt_hash")(data)
#define BC_VERIFY(data, hash) call(BYONDCRYPT, "bcrypt_verify")(data, hash)
#define BC_ED25519(data, sig, key) call(BYONDCRYPT, "ed25519_verify")(data, sig, key)

/mob/dead/unauthed
	var/current_pw_id
	var/pw_attempts = 0

/mob/dead/unauthed/proc/auth_setup()
	guess_username()
	update_supported()
	login_panel()

/mob/dead/unauthed/proc/update_supported()
	supported_login = list("password")

/mob/dead/unauthed/Topic(href, href_list)
	if(src != usr)
		return
	if(current_pw_id) // no.
		to_chat(src, "<span class='danger'>You are already attempting to log in!</span>")
		return
	if(href_list["username"])
		var/new_username = input(usr, null, "Username")
		if(new_username && length(new_username))
			var/corrected = get_correct_key(new_username)
			if(corrected)
				username = corrected
				update_supported()
				login_panel()
	if(href_list["login"])
		if(!username || !length(username))
			return
		if(logging_in)
			to_chat(src, "<span class='danger'>You are already attempting to log in!</span>")
			return
		if(next_login > world.time)
			to_chat(src, "<span class='danger'>You must wait [DisplayTimeText(next_login - world.time)] to try to login again!</span>")
			return
		var/val = text2num(href_list["login"])
		if(val == 1 && ("password" in supported_login))
			var/password = input(usr, null, "Password")
			if(password && length(password))
				var/db_pass = get_password(username)
				current_pw_id = BC_VERIFY(password, db_pass)
				log_world("[current_pw_id]")
				START_PROCESSING(SSauth, src)
				next_login = world.time + LOGIN_COOLDOWN
		else if(val == 2 && ("challenge" in supported_login))
			// in the future
			next_login = world.time + LOGIN_COOLDOWN
		else if(val == 3 && !CONFIG_GET(flag/guest_ban))
			var/client/C = client
			C.InitClient(tdata)
			client.mob = new /mob/dead/new_player
			C.PostInitClient(tdata)
			qdel(src)

/mob/dead/unauthed/process()
	if(!current_pw_id)
		return PROCESS_KILL
	if(pw_attempts > MAX_ATTEMPTS)
		current_pw_id = null
		pw_attempts = 0
		return PROCESS_KILL
	else
		var/json = BC_STATUS(current_pw_id)
		log_world("[current_pw_id]: [json]")
		var/status = json_decode(json)
		if(status["status"] == 2 && status["data"])
			if (status["data"] == "yes")
				login_as(username)
			current_pw_id = null
			pw_attempts = 0
			return PROCESS_KILL
		else
			pw_attempts++

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

/mob/dead/unauthed/proc/get_password(user)
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_pass = SSdbcore.NewQuery({"
			SELECT `password`
			FROM [format_table_name("authentication")]
			WHERE
				ckey = '[sanitizeSQL(ckey(user))]'"})
		if(!query_get_pass.Execute())
			qdel(query_get_pass)
			return
		if (query_get_pass.NextRow())
			var/pass = query_get_pass.item[1]
			if(pass)
				qdel(query_get_pass)
				return pass
		qdel(query_get_pass)

/proc/get_correct_key(user)
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

#undef LOGIN_COOLDOWN
#undef MAX_ATTEMPTS
