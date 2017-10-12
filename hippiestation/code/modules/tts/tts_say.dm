GLOBAL_VAR_INIT(hear_tts, FALSE)

/mob/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, spans, message_mode)
    . = ..(message, speaker, message_langs, raw_message, radio_freq, spans, message_mode)
    if(GLOB.hear_tts)
       tts_sayto(raw_message)

/client/proc/tts_hear()
	set category = "Fun"
	set name = "Toggle Say TTS"
    if(!check_rights(R_FUN))
		return
    if(!CONFIG_GET(string/tts_api))
        to_chat(src, "<span class='boldwarning'>Text-to-speech is not enabled.</span>")
		return FALSE
    GLOB.hear_tts = !GLOB.hear_tts
    message_admins("[key_name_admin(src)] toggled global TTS to [GLOB.hear_tts].")
    log_admin("[key_name_admin(src)] toggled global TTS to [GLOB.hear_tts].")