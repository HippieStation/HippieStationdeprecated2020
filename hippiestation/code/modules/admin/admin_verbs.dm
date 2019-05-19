/client/add_admin_verbs()
	. = ..()
	if (holder)
		var/rights = holder.rank.rights
		if(rights & R_SOUND)
			if(CONFIG_GET(flag/enable_tts))
				verbs += /client/proc/play_tts
				verbs += /client/proc/start_tts_engine

/client/remove_admin_verbs()
	. = ..()
	verbs.Remove(/client/proc/play_tts)
	verbs.Remove(/client/proc/start_tts_engine)
