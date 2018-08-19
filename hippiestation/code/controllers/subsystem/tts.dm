#define GENERATOR_PATH "tools/tts_generator/"

SUBSYSTEM_DEF(tts)
	name = "Text-to-Speech"
	wait = 2
	runlevels = (RUNLEVEL_LOBBY | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
	var/list/queue           // List of items to process
	var/datum/tts/processing // The item we're currently processing

/datum/controller/subsystem/tts/Initialize()
	LAZYINITLIST(queue)

	if (!CONFIG_GET(flag/enable_tts))
		can_fire = FALSE
	return ..()

/datum/controller/subsystem/tts/proc/check_queue(client/C)
	if (!C)
		return FALSE

	for (var/datum/tts/T in queue)
		if (T.owner == C)
			return TRUE

	return FALSE

/datum/controller/subsystem/tts/fire(resumed = FALSE)
	if (processing)
		if (!processing.owner)
			message_admins("TTS request has no owner (on check)")
			processing = null
			return

		// file not ready
		if (!fexists(processing.filename))
			if (world.time > processing.timeout)
				message_admins("[processing.owner]'s TTS request timed out!")
				processing = null
			return

		for (var/mob/M in GLOB.player_list)
			var/client/C = M.client
			if (!C)
				continue
			if (C.prefs.toggles & SOUND_TTS)
				var/turf/origin

				if (processing.is_global)
					origin = M.loc
				else
					origin = processing.owner.mob.loc

				M.playsound_local(origin, processing.filename, 100, 0, channel = CHANNEL_TTS)

		// delete the file once we play it
		fdel(processing.filename)
		processing = null
	else
		// nothing is currently being processed, take first item from the queue
		if (LAZYLEN(queue) > 0)
			processing = popleft(queue)
		else
			return // nothing to process and nothing queued

		if (!processing)
			message_admins("Error picked TTS request")
			return

		if (!processing.owner)
			message_admins("TTS request has no owner (on pick)")
			processing = null
			return
		else
			processing.owner.tts_cooldown = world.time + length(processing.text)

		processing.timeout = processing.timeout + world.time
		var/cmd = GENERATOR_PATH + "tts_generator.exe"
		cmd = cmd + " --text \"[processing.text]\""

		if (processing.voice)
			cmd = cmd + " --voice \"[processing.voice]\""
		shell(cmd)
		processing.filename = GENERATOR_PATH + "speech.ogg"

/datum/tts
	var/client/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/timeout = 10 // file shouldn't take longer than 1 second to process, delete after this much time has passed

/datum/tts/proc/say(client/C, msg, voice = "", is_global = FALSE)
	if (!C)
		return
	if (!msg)
		return
	owner = C
	text = msg
	src.voice = voice
	src.is_global = is_global

	LAZYADD(SStts.queue, src)

#undef GENERATOR_PATH