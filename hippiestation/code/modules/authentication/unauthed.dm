#define LOGIN_COOLDOWN 3 SECONDS

/mob/dead/unauthed
	flags_1 = NONE
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	stat = DEAD
	var/username
	var/challenge_uuid
	var/supported_login = list()
	var/tdata
	var/logging_in = FALSE
	var/next_login = 0

/mob/dead/unauthed/Initialize()
	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))
	return ..()

/mob/dead/unauthed/prepare_huds()
	return

/mob/dead/unauthed/proc/login_panel()
	var/output = "<center><p><b>Username: </b><a href='byond://?src=[REF(src)];username=1'>[username ? username : "Input"]</a></p></center>"
	output += "<p><center>[(username && CONFIG_GET(string/vas_server_client) && ("challenge" in supported_login)) ? "<a href='byond://?src=[REF(src)];login=1'>" : ""]Login with Password[(username && CONFIG_GET(string/vas_server_client) && ("challenge" in supported_login)) ? "</a>" : ""]</center>"
	output += "<center>[(username && ("password" in supported_login)) ? "<a href='byond://?src=[REF(src)];login=2'>" : ""]Login with Vapor-Auth Client[(username && ("password" in supported_login)) ? "</a>" : ""]</center>"
	output += "<center>[!CONFIG_GET(flag/guest_ban) ? "<a href='byond://?src=[REF(src)];login=3'>" : ""]Login as Guest[!CONFIG_GET(flag/guest_ban) ? "</a>" : ""]</center></p>"

	var/datum/browser/popup = new(src, "loginpanel", "<div align='center'>Login</div>", 250, 200)
	popup.set_window_options("can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	popup.set_content(output)
	popup.open(FALSE)

/mob/dead/unauthed/process()
	if(challenge_uuid && length(challenge_uuid) && check_challenge())
		log_game("[key]/[username] passed [challenge_uuid]")
		clear_challenge()
		login_as(username)
		return PROCESS_KILL

/mob/dead/unauthed/proc/login_as(new_key)
	if(!client)
		qdel(src)
		return
	src << browse(null, "window=loginpanel")
	var/client/C = client
	client.authenticated = TRUE
	client.prefs = null
	client.player_details = null
	GLOB.directory -= ckey
	GLOB.player_details -= ckey
	GLOB.preferences_datums -= ckey
	client.key = new_key
	GLOB.directory[C.ckey] = C
	C.InitClient(tdata)
	if(istype(C.mob, /mob/dead/unauthed))
		C.mob = new /mob/dead/new_player
	C.PostInitClient(tdata)
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_set_connect = SSdbcore.NewQuery({"
			UPDATE [format_table_name("authentication")]
			SET `last_login` = '[sanitizeSQL(md5("[C.address][C.computer_id]"))]'
			WHERE `ckey` = '[sanitizeSQL(ckey(new_key))]'
		"})
		query_set_connect.Execute()
		qdel(query_set_connect)
	qdel(src)

/mob/dead/unauthed/CanProcCall(procname)
	return procname != "login_as" && ..() // how about NO

/mob/dead/unauthed/Topic(href, href_list)
	if(src != usr)
		return
	if(href_list["username"])
		var/new_username = input(usr, null, "Username")
		if(new_username && length(new_username))
			var/corrected = get_correct_key(new_username)
			if(corrected)
				var/list/status = get_auth_status(new_username)
				if(status && status["valid"])
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
			logging_in = TRUE
			if(password && length(password) && check_password(password))
				login_as(username)
			logging_in = FALSE
			next_login = world.time + LOGIN_COOLDOWN
		else if(val == 2 && ("challenge" in supported_login))
			logging_in = TRUE
			setup_challenge()
			logging_in = FALSE
			next_login = world.time + LOGIN_COOLDOWN
		else if(val == 3 && !CONFIG_GET(flag/guest_ban))
			client.mob = new /mob/dead/new_player
			qdel(src)

#undef LOGIN_COOLDOWN
