#define BYONDCRYPT (world.system_type == MS_WINDOWS ? "byondcrypt.dll" : "byondcrypt.so")

GLOBAL_DATUM_INIT(authProvider, /datum/auth_provider, new(global_instance = TRUE))

/datum/auth_provider
	var/current_username
	var/logging_in = FALSE
	var/login_flags = NONE
	var/next_login = 0
	var/list/current_ed25519
	var/acct_ed25519
	var/acct_pass
	var/is_global = FALSE
	var/mob/dead/unauthed/linked_unauth

/datum/auth_provider/New(mob/dead/unauthed/unauth, global_instance = FALSE)
	..()
	if(global_instance)
		is_global = TRUE
	else
		if(QDELETED(unauth) || !istype(unauth))
			qdel(src)
			return
		linked_unauth = unauth

/datum/auth_provider/CanProcCall(proc_name)
	return FALSE // no.

/datum/auth_provider/Topic(href, href_list)
	if(is_global)
		return
	if(linked_unauth != usr)
		return
	if(logging_in)
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
		if(!GLOB.tffi_loaded)
			to_chat(linked_unauth, "<span class='danger'>Authentication will not work!</span>")
			return
		if(logging_in)
			to_chat(linked_unauth, "<span class='danger'>You are already attempting to log in!</span>")
			return
		if(next_login > world.time)
			to_chat(linked_unauth, "<span class='danger'>You must wait [DisplayTimeText(next_login - world.time)] to try to login again!</span>")
			return
		var/val = text2num(href_list["login"])
		if(val == 1 && (login_flags & LOGIN_PASSWORD) && acct_pass && length(acct_pass) == 60)
			var/password = input(usr, null, "Password")
			if(password && length(password))
				if(acct_pass && length(acct_pass) == 60)
					logging_in = TRUE
					call_cb(BYONDCRYPT, "bcrypt_verify", CALLBACK(src, .proc/BCVerifyCallback, current_username), password, acct_pass)
		else if(val == 2 && (login_flags & LOGIN_ED25519) && acct_ed25519 && length(acct_ed25519) == 64)
			var/client_data = list()
			client_data["ckey"] = ckey(current_username)
			client_data["url"] = "byond://[world.internet_address]:[world.port]"
			current_ed25519 = list()
			for(var/i = 1 to 32)
				LAZYADD(current_ed25519, rand(1, 255))
			client_data["data"] = current_ed25519
			logging_in = TRUE
			linked_unauth.client << link("vaporauth://[urlbase64(json_encode(client_data))]")

/datum/auth_provider/proc/LoginMenu()
	var/output = "<center><p><b>Username: </b><a href='byond://?src=[REF(src)];username=1'>[current_username ? current_username : "Input"]</a></p></center>"
	output += "<p><center>[(current_username && (login_flags & LOGIN_PASSWORD)) ? "<a href='byond://?src=[REF(src)];login=1'>" : ""]Login with Password[(current_username && (login_flags & LOGIN_PASSWORD)) ? "</a>" : ""]</center>"
	output += "<center>[(current_username && (login_flags & LOGIN_ED25519)) ? "<a href='byond://?src=[REF(src)];login=2'>" : ""]Login with Vapor-Auth-Client[(current_username && (login_flags & LOGIN_ED25519)) ? "</a>" : ""]</center>"
	output += "<center>[!CONFIG_GET(flag/guest_ban) ? "<a href='byond://?src=[REF(src)];login=3'>" : ""]Login as Guest[!CONFIG_GET(flag/guest_ban) ? "</a>" : ""]</center></p>"
	return output

/datum/auth_provider/proc/Update()
	if(!current_username || !length(current_username) || is_global)
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
				acct_pass = query_get_logins.item[1]
			if(query_get_logins.item[2] && length(query_get_logins.item[2]) == 64)
				login_flags |= LOGIN_ED25519
				acct_ed25519 = query_get_logins.item[2]

/datum/auth_provider/proc/Setup()
	if(is_global)
		return
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

/datum/auth_provider/proc/AuthStatus(ckey)
	return istext(get_correct_key(ckey))

/datum/auth_provider/proc/AuthTopic(list/input)
	if(!GLOB.tffi_loaded || is_global)
		return
	if(!((login_flags & LOGIN_ED25519) && LAZYLEN(acct_ed25519) == 64))
		return
	if(input["ckey"] != ckey(current_username) || !LAZYLEN(input["data"]))
		return
	var/hexed_data = ""
	var/hexed_sig = ""
	for(var/i in 1 to length(input["data"]))
		hexed_sig = "[hexed_sig][dec2hex(input["data"][i])]"
	for(var/i in 1 to length(current_ed25519))
		hexed_data = "[hexed_data][dec2hex(current_ed25519[i])]"
	call_cb(BYONDCRYPT, "ed25519_verify", CALLBACK(src, .proc/Ed25519Callback, current_username), hexed_data, hexed_sig, acct_ed25519)

/datum/auth_provider/proc/Ed25519Callback(username, resp)
	logging_in = FALSE
	if(ckey(username) != ckey(current_username))
		message_admins("Possible attempt to spoof login as [current_username] (tried to login as [username])")
		return
	if(resp == "yes")
		to_chat(linked_unauth, "<span class='big notice bold'>Logged in successfully!</span>")
		linked_unauth.login_as(current_username)
	else
		to_chat(linked_unauth, "<span class='danger'>Invalid auth response: <i><b>\"[resp]\"</b></i></span>")

/datum/auth_provider/proc/BCVerifyCallback(username, resp)
	logging_in = FALSE
	if(ckey(username) != ckey(current_username))
		message_admins("Possible attempt to spoof login as [current_username] (tried to login as [username])")
		return
	if(resp == "yes")
		linked_unauth.login_as(current_username)
	else
		to_chat(linked_unauth, "<span class='danger'>Wrong password!</span>")
		next_login = world.time + AUTH_COOLDOWN

/datum/auth_provider/proc/AccountManager(client/user, updating = FALSE)
	var/list/methods = list("Challenge-Response (requires vapor-auth-client)", "Password", "I'm done!")
	var/list/data = list("ckey" = user.ckey)
	while(TRUE)
		var/ret = input(usr, "Please select the login method to configure", "Register") as anything in methods
		if(ret == "I'm done!")
			if(data.len == 1)
				to_chat(usr, "<span class='danger bold italics'>[updating ? "Update" : "Registration"] canceled.</span>")
				return FALSE
			else
				break
		else
			switch(ret)
				if("Challenge-Response (requires vapor-auth-client)")
					to_chat(usr, "<span class='big notice'>Click <a href='https://github.com/steamp0rt/vapor-auth'><b>here</b></a> for vapor-auth-client.</span>")
					var/pubkey = input(usr, "Please paste your public key from 'vapor-auth-client keygen' here.", "Register") as null|text 
					var/list/decoded = base64bin(pubkey)
					decoded.len-- // because this puts a null at the end for some stupid reason and i don't wanna fix it
					if(!LAZYLEN(decoded) || length(decoded) != 32)
						to_chat(usr, "<span class='danger bold italics'>Invalid public key. It should be a 42+ character Base64 string.</span>")
						continue
					var/hexed_key = ""
					for(var/i in 1 to length(decoded))
						hexed_key = "[hexed_key][dec2hex(decoded[i])]"
					data["pubkey"] = hexed_key
				if("Password")
					var/pass = input(usr, "Please insert your password.", "Register") as null|text 
					if(length(pass) < 8)
						to_chat(usr, "<span class='danger bold italics'>Password must be at least 8 characters.</span>")
						continue
					var/lowerpass = lowertext(pass)
					if(findtext(lowerpass, "password") || findtext(lowerpass, "hunter2") || findtext(lowerpass, "12345") || findtext(lowerpass, user.ckey) || findtext(lowerpass, "qwerty") || findtext(lowerpass, "abcde"))
						to_chat(usr, "<span class='danger bold italics'>That's a garbage password.</span>")
						continue
					data["password"] = pass
	if(SSdbcore.Connect())
		var/pubkey
		var/password
		if(data["pubkey"])
			pubkey = "UNHEX('[sanitizeSQL(data["pubkey"])]')"
		if(data["password"])	
			var/hashed = call_wait(BYONDCRYPT, "bcrypt_hash", data["password"])
			if(!hashed)
				return
			password = "'[sanitizeSQL(hashed)]'"
		if(!pubkey && !password)
			to_chat(usr, "<span class='notice bold'>Neither a password or public key was supplied.</span>")
			return
		if(updating)
			var/datum/DBQuery/query_set_connect = SSdbcore.NewQuery({"
				UPDATE [format_table_name("authentication")]
				SET `last_login` = '[sanitizeSQL(md5("[user.address][user.computer_id]"))]',
				[pubkey ? "SET `pubkey` = [pubkey]," : ""]
				[password ? "SET `password` = [password]," : ""]
				WHERE `ckey` = '[sanitizeSQL(user.ckey)]'
			"})
			query_set_connect.warn_execute()
			qdel(query_set_connect)
		else
			var/datum/DBQuery/query_insert_auth = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("authentication")] 
				(`ckey`, `key`, `last_login`, `password`, `pubkey`) 
				VALUES ('[sanitizeSQL(user.ckey)]', '[sanitizeSQL(user.key)]', '[sanitizeSQL(md5("[user.address][user.computer_id]"))]', [password || "NULL"], [pubkey || "NULL"])
				"})
			query_insert_auth.warn_execute()
			qdel(query_insert_auth)
	log_game("[user.ckey] successfully [updating ? "updated their" : "registered an"] account.")
	to_chat(usr, "<span class='notice bold'>[updating ? "Update" : "Registration"] successful.</span>")
	return TRUE

/proc/dec2hex(n)
    return "[round(n/16)%16>9?ascii2text(round(n/16)%16+55):round(n/16)%16][n%16>9?ascii2text(n%16+55):n%16]"
