GLOBAL_VAR_INIT(allow_antag_tokens, TRUE)
GLOBAL_VAR_INIT(allow_antag_token_mode, TRUE)
GLOBAL_VAR(current_token_forced)

/mob/dead/new_player
	var/using_token = FALSE

/mob/dead/new_player/proc/hippie_new_player_panel()
	if(!client.ticket_holder)
		return ""
	if(!LAZYLEN(client.ticket_holder.antag_tickets))
		return "<p>\[Use Token\] | \[Don't Use Token\] | \[Gamemode\]</p>"
	if(using_token)
		return "<p><b>\[Use Antag Token\]</b> | <a href='byond://?src=[REF(src)];token=0'>Don't Use Antag Token</a> | <a href='byond://?src=[REF(src)];gamemode=1'>Gamemode</a></p>"
	else
		return "<p><a href='byond://?src=[REF(src)];token=1'>Use Antag Token</a> | <b>\[Don't Use Antag Token\]</b> | \[Gamemode\]</p>"


/mob/dead/new_player/Topic(href, href_list[])
	. = ..()
	if(href_list["token"] != null)
		if(!LAZYLEN(client.ticket_holder.antag_tickets))
			using_token = FALSE
			GLOB.token_users[ckey] = FALSE
			to_chat(usr, "<span class='warning'>You have no antag tokens to spend!</span>")
			return
		using_token = text2num(href_list["token"])
		GLOB.token_users[ckey] = text2num(using_token)
	if(href_list["gamemode"])
		if(!LAZYLEN(client.ticket_holder.antag_tickets))
			using_token = FALSE
			GLOB.token_users[ckey] = FALSE
			to_chat(usr, "<span class='warning'>You have no antag tokens to spend!</span>")
			return
		if(!GLOB.allow_antag_token_mode || !GLOB.allow_antag_tokens)
			to_chat(usr, "<span class='warning'>Using antag tokens is currently not allowed, sorry about that.</span>")
			return
		if(GLOB.current_token_forced)
			var/datum/mode_ticket/MT = GLOB.current_token_forced
			if(MT && MT.ckey != ckey)
				to_chat(usr, "<span class='warning'>Sorry, first come, first serve!</span>")
				return
		var/list/valid_modes = list("none")
		for(var/G in config.gamemode_cache)
			var/datum/game_mode/GM = G
			var/config_tag = initial(GM.config_tag)
			var/antag_flag = initial(GM.antag_flag)
			if(CONFIG_GET(keyed_list/token_mode)[config_tag] && client.ticket_holder.CanRedeemFor(antag_flag))
				valid_modes += config_tag
		var/GM = input(usr, "Please enter the gamemode you want.", "Antag Token", "") as null|anything in valid_modes
		if(GM)
			if(GM == "none")
				GLOB.current_token_forced = null
			else
				GLOB.current_token_forced = new /datum/mode_ticket(ckey, GM, client.ticket_holder)
				message_admins("[key_name(usr)] forced the \"[GM]\" gamemode with an antag token!")
				log_game("[key_name(usr)] forced the \"[GM]\" gamemode with an antag token!")

/mob/dead/new_player/IsJobUnavailable(rank, latejoin = FALSE)
	. = ..()
	if(. == JOB_AVAILABLE)
		if(is_banned_from(src.ckey, list(CLUWNEBAN,CATBAN)) && rank != SSjob.overflow_role)
			return JOB_UNAVAILABLE_BANNED
