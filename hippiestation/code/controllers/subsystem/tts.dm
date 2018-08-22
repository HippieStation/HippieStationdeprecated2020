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
				T.filename = GENERATOR_PATH + uid + "_speech"
				continue
			if (STATUS_GENERATING)
				/* Check if this file is ready */
				if (fexists(T.filename + ".ogg") && fexists(T.filename + ".meta") && !fexists(T.filename + ".lock"))
					play_tts(T)
				continue
			if (STATUS_PLAYING)
				/* Delete the file when it's finished */
				if (world.time > T.life)
					if (T.filename)
						fdel(T.filename + ".ogg")
						fdel(T.filename + ".wav")
						fdel(T.filename + ".meta")
					LAZYREMOVE(processing, T)
				continue

/datum/controller/subsystem/tts/proc/play_tts(datum/tts/T)
	if (!T.owner)
		message_admins("TTS request has no owner")
		return
	if (!T.owner.mob)
		message_admins("TTS request has no mob")
		return

	var/next_channel = open_sound_channel()

	T.status = STATUS_PLAYING

	if (T.is_global)
		for (var/mob/M in GLOB.player_list)
			if (!M.client)
				continue
			if (!(M.client.prefs.toggles & SOUND_TTS))
				continue

			M.playsound_local(M.loc, T.filename + ".ogg", 100, 0, channel=next_channel)
	else
		var/turf/origin = T.owner.mob.loc

		var/list/listeners = GLOB.player_list
		listeners = listeners & hearers(world.view, origin)

		// get length of audio file
		var/audio_length = text2num(file2text(T.filename + ".meta"))
		audio_length = audio_length / 100
		if (!audio_length)
			audio_length = length(T.text)

		T.life = world.time + audio_length
		T.owner.tts_cooldown = world.time + audio_length

		addtimer(CALLBACK(T.owner.mob, /mob/living.proc/update_tts_hud), audio_length)

		for (var/mob/P in listeners)
			if (!P.client)
				continue
			if (!(P.client.prefs.toggles & SOUND_TTS))
				continue
			if (T.language)
				if (!P.can_speak_in_language(T.language))
					continue

			if (get_dist(P, origin) <= world.view)
				var/turf/Turf = get_turf(P)

				if (Turf && Turf.z == origin.z)
					P.playsound_local(origin, T.filename + ".ogg", 100 * T.volume_mod, 0, channel=next_channel)

/datum/tts
	var/client/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/status = STATUS_NEW
	var/life = 0
	var/datum/language/language
	var/volume_mod = 1

/datum/tts/proc/say(client/C, msg, voice = "", is_global = FALSE, volume_mod = 1, datum/language/language)
	if (!C)
		return
	if (!msg)
		return
	owner = C
	text = msg
	src.voice = voice
	src.is_global = is_global
	src.volume_mod = volume_mod
	src.language = language

	LAZYADD(SStts.processing, src)

#undef GENERATOR_PATH
#undef STATUS_NEW
#undef STATUS_GENERATING
#undef STATUS_READY
#undef STATUS_PLAYING