/mob/dead/new_player
	var/using_token = FALSE

/mob/dead/new_player/Topic(href, href_list[])
	. = ..()
	if(href_list["token"] != null)
		if(!LAZYLEN(client.ticket_holder.antag_tickets))
			using_token = FALSE
			GLOB.token_users[ckey] = FALSE
			to_chat(usr, "<span class='warning'>You have no antag tokens to spend!</span>")
			return
		using_token = href_list["token"]
		GLOB.token_users[ckey] = text2num(using_token)

/mob/dead/new_player/IsJobUnavailable(rank, latejoin = FALSE)
	. = ..()
	if(. == JOB_AVAILABLE)
		if(is_banned_from(src.ckey, list(CLUWNEBAN,CATBAN)) && rank != SSjob.overflow_role)
			return JOB_UNAVAILABLE_BANNED
