SUBSYSTEM_DEF(tts)
	name = "Text-to-Speech"
	wait = 2
	var/list/queue           // List of items to process
	var/datum/tts/processing // The item we're currentl processing

/datum/tts
	var/mob/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/timeout = 10 // file shouldn't take longer than 1 second to process, delete after this much time has passed

/datum/tts/proc/Initialize()
	. = ..()

/datum/tts/proc/say(mob/M, msg, voice = "", is_global = FALSE)
	if (!M)
		return
	if (!msg)
		return
	owner = M
	text = msg
	src.voice = voice
	src.is_global = is_global

	LAZYADD(SStts.queue, src)

/datum/controller/subsystem/tts/Initialize()
	LAZYINITLIST(queue)

	if (!CONFIG_GET(flag/enable_tts))
		can_fire = FALSE
	return ..()

/datum/controller/subsystem/tts/fire(resumed = FALSE)
	if (processing)
		// file not ready
		if (!fexists(processing.filename))
			if (world.time > processing.timeout)
				processing = null
			return

		if (!processing.owner)
			processing = null
			return

		for (var/P in GLOB.player_list)
			var/mob/M = P
			if (!M)
				continue
			var/client/C = M.client
			if (!C)
				continue
			if (C.prefs.toggles & SOUND_MIDI)
				var/turf/origin

				if (processing.is_global)
					origin = M.loc
				else
					origin = processing.owner.loc

				M.playsound_local(origin, processing.filename, 100, 0)

		// delete the file once we play it
		if (fexists(processing.filename))
			fdel(processing.filename)
		processing = null
	else
		// nothing is currently being processed, take first item from the queue
		if (LAZYLEN(queue) > 0)
			processing = popleft(queue)
		else
			return // nothing to process and nothing queued

		if (!processing)
			return

		processing.timeout = processing.timeout + world.time
		var/cmd = "tts_generator/tts_generator.exe"
		cmd = cmd + " --text \"[processing.text]\""

		if (processing.voice)
			cmd = cmd + " --voice \"[processing.voice]\""
		shell(cmd)
		processing.filename = "tts_generator/speech.ogg"

/client/proc/play_tts()
	set category = "Fun"
	set name = "Play TTS"
	if(!check_rights(R_SOUNDS))
		return
	if (!CONFIG_GET(flag/enable_tts))
		to_chat(usr, "<span='warning'>Text-to-Speech is not enabled!</span>")
		return

	var/input = input(usr, "Please enter a message to send to the server", "Text to Speech", "")
	if(input)
		var/datum/tts/T = new /datum/tts()
		T.say(mob, input, is_global=TRUE)

/mob/living/carbon/human
	var/tts_cooldown = 0
	var/tts_voice = ""

/mob/living/carbon/human/Initialize()
	. = ..()
	if (gender == FEMALE)
		tts_voice = pick("betty", "rita", "ursula", "wendy")
	else
		tts_voice = pick("dennis", "frank", "harry", "kit", "paul")

/mob/living/carbon/human/say(message, datum/language/language = null)
	. = ..()

	// only use TTS for those who want it
	if (CONFIG_GET(flag/enable_tts))
		var/client/C = src.client
		if (C)
			if (C.prefs.toggles & SOUND_MIDI)
				if (world.time > tts_cooldown)
					var/datum/tts/T = new /datum/tts()
					T.say(src, message, voice = tts_voice)
					tts_cooldown = world.time + length(message)