/client/New()
	. = ..()
	mentor_datum_set()

/client/proc/hippie_client_procs(href_list)
	if(href_list["mentor_msg"])
		if(CONFIG_GET(flag/mentors_mobname_only))
			var/mob/M = locate(href_list["mentor_msg"])
			cmd_mentor_pm(M,null)
		else
			cmd_mentor_pm(href_list["mentor_msg"],null)
		return TRUE

	//Mentor Follow
	if(href_list["mentor_follow"])
		var/mob/living/M = locate(href_list["mentor_follow"])

		if(istype(M))
			mentor_follow(M)
		return TRUE

/client/proc/mentor_datum_set(admin)
	mentor_datum = GLOB.mentor_datums[ckey]
	if(!mentor_datum && check_rights_for(src, R_ADMIN,0)) // admin with no mentor datum?let's fix that
		new /datum/mentors(ckey)
	if(mentor_datum)
		if(!check_rights_for(src, R_ADMIN,0) && !admin)
			GLOB.mentors |= src // don't add admins to this list too.
		mentor_datum.owner = src
		add_mentor_verbs()
		mentor_memo_output("Show")

/client/proc/is_mentor() // admins are mentors too.
	if(mentor_datum || check_rights_for(src, R_ADMIN,0))
		return TRUE

/client/proc/play_tts()
	set category = "Fun"
	set name = "Play TTS"
	if(!check_rights(R_SOUND))
		return
	if (!CONFIG_GET(flag/enable_tts))
		to_chat(usr, "<span='warning'>Text-to-Speech is not enabled!</span>")
		return

	var/input = input(usr, "Please enter a message to send to the server", "Text to Speech", "")
	if(input)
		var/datum/tts/T = new /datum/tts()
		T.say(src, input, is_global=TRUE)

		to_chat(world, "<span class='boldannounce'>An admin used Text-to-Speech: [input]</span>")
		log_admin("[key_name(src)] used Text-to-Speech: [input]")
		message_admins("[key_name_admin(src)] used Text-to-Speech: [input]")

		SSblackbox.record_feedback("tally", "admin_verb", 1, "Play TTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/start_tts_engine()
	set category = "Debug"
	set name = "Start TTS Engine"

	if (!check_rights(R_DEBUG))
		return
	if (!CONFIG_GET(flag/enable_tts))
		to_chat(usr, "<span='warning'>Text-to-Speech is not enabled!</span>")
		return

	if (SStts)
		SStts.start_engine()

/client/proc/add_ooc_icons()
	var/icons = ""
	if(holder)
		if(!holder.fakekey)
			if(check_rights_for(src, R_ADMIN))
				icons += "[icon2html('hippiestation/icons/ooc_icons/banhammer.dmi', world)]"
	if(is_mentor())
		if(!holder)
			icons += "[icon2html('hippiestation/icons/ooc_icons/brain.dmi', world)]"
	if(is_donator)
		icons += "[icon2html('hippiestation/icons/ooc_icons/gold_coin.dmi', world)]"
	return icons
