/mob/dead/unauthed
	flags_1 = NONE
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	stat = DEAD
	var/datum/auth_provider/provider
	var/tdata
	var/logging_in = FALSE
	var/next_login = 0

/mob/dead/unauthed/Initialize()
	if(length(GLOB.newplayer_start))
		forceMove(pick(GLOB.newplayer_start))
	else
		forceMove(locate(1,1,1))
	return ..()

/mob/dead/unauthed/Destroy()
	qdel(provider)
	return ..()

/mob/dead/unauthed/prepare_huds()
	return

/mob/dead/unauthed/proc/login_panel()
	var/datum/browser/popup = new(src, "loginpanel", "<div align='center'>Login</div>", 250, 200)
	popup.set_window_options("can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0")
	popup.set_content(provider.LoginMenu())
	popup.open(FALSE)

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
	// some workarounds to prevent runtimes
	client.prefs = GLOB.preferences_datums[new_key]
	if(client.prefs)
		client.prefs.parent = client
	else
		client.prefs = new /datum/preferences(client, new_key)
		GLOB.preferences_datums[new_key] = client.prefs
	if(GLOB.player_details[new_key])
		client.player_details = GLOB.player_details[new_key]
		client.player_details.byond_version = "[client.byond_version].[client.byond_build || "xxx"]"
	else
		client.player_details = new
		client.player_details.byond_version = "[client.byond_version].[client.byond_build || "xxx"]"
		GLOB.player_details[new_key] = client.player_details
	client.key = new_key
	GLOB.directory[C.ckey] = C
	var/list/banned = world.IsBanned(C.ckey, C.address, C.computer_id, real_bans_only=TRUE)
	if(LAZYLEN(banned))
		overlay_fullscreen("ban_message", /obj/screen/fullscreen/ban_message)
		to_chat(C, "<span class='boldannounce big'>You are banned from the server.</span>")
		to_chat(C, banned["desc"])
		sleep(5)
		qdel(C)
		qdel(src)
		return
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
	return FALSE

/mob/dead/unauthed/proc/auth_setup()
	provider = new(src, FALSE)
	provider.Setup()
	login_panel()
