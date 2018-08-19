#define GENERATOR_PATH "tools/tts_generator/"
#define STATUS_NEW		0
#define STATUS_GENERATING 1
#define STATUS_PLAYING	2

SUBSYSTEM_DEF(tts)
	name = "Text-to-Speech"
	wait = 2
	runlevels = (RUNLEVEL_LOBBY | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
	var/list/processing // List of items to process

/datum/controller/subsystem/tts/Initialize()
	LAZYINITLIST(processing)

	if (!CONFIG_GET(flag/enable_tts))
		can_fire = FALSE
	return ..()

/datum/controller/subsystem/tts/proc/check_processing(client/C)
	if (!C)
		return FALSE

	for (var/datum/tts/T in processing)
		if (T.owner == C)
			return TRUE

	return FALSE

/datum/controller/subsystem/tts/fire(resumed = FALSE)
	if (!LAZYLEN(processing))
		return

	for (var/datum/tts/T in processing)
		switch(T.status)
			if (STATUS_NEW)
				/* Start generating the sound */
				T.status = STATUS_GENERATING
				var/uid = "[world.time]" + T.owner.ckey
				var/cmd = GENERATOR_PATH + "tts_generator.exe"
				cmd = cmd + " --output \"" + uid + "_speech.wav\""
				cmd = cmd + " --text \"[T.text]\""

				if (T.voice)
					cmd = cmd + " --voice \"[T.voice]\""
				shell(cmd)
				T.filename = GENERATOR_PATH + uid + "_speech.ogg"
				continue
			if (STATUS_GENERATING)
				/* Check if this file is ready */
				if (fexists(T.filename))
					play_tts(T)
				continue
			if (STATUS_PLAYING)
				/* Delete the file when it's finished */
				if (world.time > T.life)
					if (T.filename)
						fdel(T.filename)
					LAZYREMOVE(processing, T)
				continue

/datum/controller/subsystem/tts/proc/play_tts(datum/tts/T)
	if (!T.owner)
		message_admins("TTS request has no owner")
		return
	if (!T.owner.mob)
		message_admins("TTS request has no mob")
		return

	T.status = STATUS_PLAYING

	for (var/mob/M in GLOB.player_list)
		var/client/C = M.client
		if (!C)
			continue
		if (!(C.prefs.toggles & SOUND_TTS))
			continue
		var/turf/origin

		if (T.is_global)
			origin = M.loc
		else
			origin = T.owner.mob.loc

		M.playsound_local(origin, T.filename, 100, 0, channel = CHANNEL_TTS)

/datum/tts
	var/client/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/status = STATUS_NEW
	var/life = 0

/datum/tts/proc/say(client/C, msg, voice = "", is_global = FALSE)
	if (!C)
		return
	if (!msg)
		return
	owner = C
	text = msg
	src.voice = voice
	src.is_global = is_global
	life = world.time + length(msg)

	LAZYADD(SStts.processing, src)

#undef GENERATOR_PATH
#undef STATUS_NEW
#undef STATUS_GENERATING
#undef STATUS_READY
#undef STATUS_PLAYING