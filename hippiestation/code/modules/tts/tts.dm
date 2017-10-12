/client/proc/play_tts()
	set category = "Fun"
	set name = "Play TTS"
	if(!check_rights(R_SOUNDS))
		return
	var/input = stripped_input(usr, "Please enter a message to send to the server", "Text to Speech", "")
	if(input)
		if(!tts_sayall(input))
			to_chat(src, "<span class='boldwarning'>Text-to-speech is not enabled.</span>")
		else
			message_admins("[key_name_admin(src)] played TTS: \"[input]\".")
			log_admin("[key_name(src)] played TTS: \"[input]\".")

/proc/tts_sayall(msg)
	if(!CONFIG_GET(string/tts_api))
		return FALSE
	for(var/m in GLOB.player_list)
		var/mob/M = m
		. = M.tts_sayto(msg)

/mob/proc/tts_sayto(msg)
	var/ttsurl = CONFIG_GET(string/tts_api)
	if(!ttsurl)
		return FALSE
	if(msg)
		var/client/C = client //cache it!
		var/mesg = url_encode(msg)
		if((C.prefs.toggles & SOUND_MIDI) && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
			to_chat(M, "<audio autoplay><source src=\"[ttsurl][mesg]\" type=\"audio/mpeg\"></audio>")
		return TRUE