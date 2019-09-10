/client/proc/register_account()
	set name = "Register/Update Account"
	set category = "OOC"
	if(IsGuestKey(key))
		to_chat(src, "<span class='danger bold italics'>Guests cannot create accounts!</span>")
		return
	if(!CONFIG_GET(flag/vas_auth) || !CONFIG_GET(string/vas_server) || !length(CONFIG_GET(string/vas_server)))
		to_chat(src, "<span class='danger bold italics'>Authentication is not setup!</span>")
		return
	if(!SSauth.initialized)
		return
	if(SSauth.initialized && !SSauth.can_fire)
		to_chat(src, "<span class='big danger'>Warning: authentication is currently offline. Please contact admins.</span>")
		return
	var/list/status = get_auth_status(ckey)
	var/is_updating = FALSE
	if(LAZYLEN(status))
		if(status["valid"])
			is_updating = TRUE
		if(alert("[is_updating ? "Would you like to update your account details? Old details will be lost!" : "Would you like to sign up for an account?\nThis will allow you to login when the BYOND Hub is down!"]", "Register", "Yes", "No") == "Yes")
			var/list/methods = list("Challenge-Response (requires vapor-auth-client)", "Password", "I'm done!")
			var/list/data = list("ckey" = ckey)
			while(TRUE)
				var/ret = input(usr, "Please select the login method to configure", "Register") as anything in methods
				if(ret == "I'm done!")
					if(data.len == 1)
						to_chat(src, "<span class='danger bold italics'>[is_updating ? "Update" : "Registration"] canceled.</span>")
						return
					else
						break
				else
					switch(ret)
						if("Challenge-Response (requires vapor-auth-client)")
							to_chat(usr, "<span class='big notice'>Click <a href='https://github.com/steamp0rt/vapor-auth'><b>here</b></a> for vapor-auth-client.</span>")
							var/pubkey = input(usr, "Please paste your 42-character public key from 'vapor-auth-client keygen' here.", "Register") as null|text 
							var/list/decoded = base64bin(pubkey)
							decoded.len-- // because this puts a null at the end for some stupid reason and i don't wanna fix it
							if(!LAZYLEN(decoded) || length(decoded) != 32)
								to_chat(src, "<span class='danger bold italics'>Invalid public key. It should be a 42+ character Base64 string.</span>")
								continue
							data["pubkey"] = decoded
						if("Password")
							var/pass = input(usr, "Please insert your password.", "Register") as null|text 
							if(length(pass) < 8)
								to_chat(src, "<span class='danger bold italics'>Password must be at least 8 characters.</span>")
								continue
							if(findtext(lowertext(pass), "password") || findtext(lowertext(pass), "hunter2") || findtext(lowertext(pass), "12345") || findtext(lowertext(pass), ckey) || findtext(lowertext(pass), "qwerty"))
								to_chat(src, "<span class='danger bold italics'>That's a garbage password.</span>")
								continue
							data["password"] = pass
			var/list/http[] = world.Export("[CONFIG_GET(string/vas_server)]/register/[urlbase64(json_encode(data))]")
			if(SSdbcore.Connect())
				if(is_updating)
					var/datum/DBQuery/query_set_connect = SSdbcore.NewQuery({"
						UPDATE [format_table_name("authentication")]
						SET `last_login` = '[sanitizeSQL(md5("[address][computer_id]"))]'
						WHERE `ckey` = '[sanitizeSQL(ckey)]'
					"})
					query_set_connect.Execute()
					qdel(query_set_connect)
				else
					var/datum/DBQuery/query_insert_auth = SSdbcore.NewQuery({"
						INSERT INTO [format_table_name("authentication")] 
						(`ckey`, `key`, `last_login`) 
						VALUES ('[sanitizeSQL(ckey)]', '[sanitizeSQL(key)]', '[sanitizeSQL(md5("[address][computer_id]"))]')
						"})
					query_insert_auth.Execute()
					qdel(query_insert_auth)
			log_game("[ckey] successfully [is_updating ? "updated their" : "registered an"] account.")
			to_chat(src, "<span class='notice bold'>[is_updating ? "Update" : "Registration"] successful.</span>")
			verbs -= /client/proc/register_account
