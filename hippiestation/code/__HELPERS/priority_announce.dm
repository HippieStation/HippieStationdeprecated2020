// This just replaces a sound.

minor_announce(message, title = "Attention:", alert)
	if(!message)
		return

	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear())
			to_chat(M, "<span class='big bold'><font color = red>[html_encode(title)]</font color><BR>[html_encode(message)]</span><BR>")
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				if(alert)
					SEND_SOUND(M, sound('hippiestation/sound/misc/notice1.ogg'))
				else
					SEND_SOUND(M, sound('hippiestation/sound/misc/notice2.ogg'))