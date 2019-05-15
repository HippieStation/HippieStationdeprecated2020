/mob/living/carbon/human/treat_message(message)
	if(lisp)
		message = lisp(message, lisp)
	return ..()

/mob/living/can_speak_vocal(message)
	if(pulledby && pulledby.grab_state == GRAB_KILL)
		return FALSE

	return ..()

/mob/living/say(message, bubble_type,var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	// If we're in soft crit and tried to talk, automatically make us whisper
	if (length(message) > 2)
		var/first_char = copytext(message, 1, 2)

		if (first_char != "*" && stat == SOFT_CRIT && get_message_mode(message) != MODE_WHISPER)
			message = "#" + message

	. = ..()

	if (!.)
		return

	if(findtext(message, "nigger"))	//You're an idiot and should feel as such
		var/mob/living/carbon/human/H = src
		to_chat(src, "<span class='warning'><b>You feel like a fucking idiot.</b></span>")
		playsound_local(src, 'hippiestation/sound/effects/whistlefail.ogg', 50, 0)	//Rip
		if(istype(src, /mob/living/carbon/human/))
			var/trauma_type = pickweight(list(BRAIN_TRAUMA_MILD = 100,BRAIN_TRAUMA_SEVERE = 30,BRAIN_TRAUMA_MAGIC = 10,BRAIN_TRAUMA_SPECIAL = 1))
			var/trauma_resistance
			switch(trauma_type)
				if(BRAIN_TRAUMA_MILD)
					trauma_resistance = TRAUMA_RESILIENCE_BASIC
				if(BRAIN_TRAUMA_SEVERE)
					trauma_resistance = TRAUMA_RESILIENCE_SURGERY
				if(BRAIN_TRAUMA_MAGIC)
					trauma_resistance = TRAUMA_RESILIENCE_MAGIC
				if(BRAIN_TRAUMA_SPECIAL)
					trauma_resistance = TRAUMA_RESILIENCE_BASIC
			H.adjustBrainLoss(20)
			H.gain_trauma_type(trauma_type, trauma_resistance)

/*
	say_tts(message, language) TTS removed, leaving handlers here for replacement

/mob/living/proc/say_tts(tts_message, datum/language/tts_language = null)
	if (!CONFIG_GET(flag/enable_tts))
		return
	if (!client)
		return

	tts_message = trim(copytext(sanitize_simple(tts_message, list("\""="", "\n"=" ", "\t"=" ")), 1, MAX_MESSAGE_LEN * 10))
	if (!tts_message)
		return

	var/talk_key = get_key(tts_message)

	var/static/list/one_character_prefix = list(MODE_HEADSET = TRUE, MODE_ROBOT = TRUE, MODE_WHISPER = TRUE)

	var/datum/saymode/saymode = SSradio.saymodes[talk_key]
	var/message_mode = get_message_mode(tts_message)

	if(one_character_prefix[message_mode])
		tts_message = copytext(tts_message, 2)
	else if(message_mode || saymode)
		tts_message = copytext(tts_message, 3)
	if(findtext(tts_message, " ", 1, 2))
		tts_message = copytext(tts_message, 2)

	// language comma detection.
	var/datum/language/message_language = get_message_language(tts_message)
	if(message_language)
		// No, you cannot speak in xenocommon just because you know the key
		if(can_speak_in_language(message_language))
			tts_language = message_language
		tts_message = copytext(tts_message, 3)

		// Trim the space if they said ",0 I LOVE LANGUAGES"
		if(findtext(tts_message, " ", 1, 2))
			tts_message = copytext(tts_message, 2)

	if(!tts_language)
		tts_language = get_default_language()

	tts_message = treat_message(tts_message)

	var/tts_voice = ""

	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src

		if (H)
			if (H.dna)
				if (H.dna.tts_voice)
					tts_voice = H.dna.tts_voice

	if (world.time > client.tts_cooldown && !SStts.check_processing(src))
		var/tts_volume_mod = 1
		if (message_mode == MODE_WHISPER)
			tts_volume_mod /= 2

		var/datum/tts/TTS = new /datum/tts()
		TTS.say(client, tts_message, voice = tts_voice, volume_mod = tts_volume_mod, language = tts_language)

		if (!hud_used)
			return
		if (!hud_used.tts)
			return
		hud_used.tts.icon_state = "tts_cooldown"
*/
