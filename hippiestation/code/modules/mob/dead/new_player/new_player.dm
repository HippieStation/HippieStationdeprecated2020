GLOBAL_VAR_INIT(allow_antag_tokens, TRUE)

/mob/dead/new_player
	var/using_token = FALSE

/mob/dead/new_player/proc/hippie_new_player_panel()
	if(!client.ticket_holder)
		return ""
	if(!LAZYLEN(client.ticket_holder.antag_tickets))
		return "<p>\[Use Token\] | \[Don't Use Token\] | \[Gamemode\]</p>"
	if(using_token)
		return "<p><b>\[Use Antag Token\]</b> | <a href='byond://?src=[REF(src)];token=0'>Don't Use Antag Token</a></p>"
	else
		return "<p><a href='byond://?src=[REF(src)];token=1'>Use Antag Token</a> | <b>\[Don't Use Antag Token\]</b></p>"


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

/mob/dead/new_player/IsJobUnavailable(rank, latejoin = FALSE)
	. = ..()
	if(. == JOB_AVAILABLE)
		if(is_banned_from(src.ckey, list(CLUWNEBAN,CATBAN)) && rank != SSjob.overflow_role)
			return JOB_UNAVAILABLE_BANNED
