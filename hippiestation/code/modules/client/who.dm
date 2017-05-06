/client/verb/mentorwho()
	set category = "Mentor"
	set name = "Mentorwho"
	var/msg = "<b>Current Mentors:</b>\n"
	for(var/X in GLOB.admins)
		var/client/C = X
		if(!check_rights_for(C, R_ADMIN))
			continue
		if(check_rights_for(C, R_MENTOR))
			var/suffix = ""
			if(holder)
				if(isobserver(C.mob))
					suffix += " - Observing"
				else if(istype(C.mob,/mob/dead/new_player))
					suffix += " - Lobby"
				else
					suffix += " - Playing"

				if(C.is_afk())
					suffix += " (AFK)"
			msg += "\t[C][suffix]\n"
	to_chat(src, msg)