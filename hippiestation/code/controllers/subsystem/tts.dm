#define GENERATOR_PATH    "tts_generator\\"
#define DATA_PATH         GENERATOR_PATH + "data\\"
#define STATUS_NEW        0
#define STATUS_GENERATING 1
#define STATUS_PLAYING    2

PROCESSING_SUBSYSTEM_DEF(tts)
	name = "Text-to-Speech"
	wait = 2
	runlevels = (RUNLEVEL_LOBBY | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
	var/list/ckeys_playing = list()// list of ckeys of users currently playing a tts sound

/datum/controller/subsystem/processing/tts/Initialize()
	if (!CONFIG_GET(flag/enable_tts))
		can_fire = FALSE
	else
		start_engine()

	return ..()

/datum/controller/subsystem/processing/tts/proc/start_engine()
	if (!CONFIG_GET(flag/enable_tts))
		return
	var/cmd = "cmd /c start \"tts_generator\" [GENERATOR_PATH]tts_generator.exe"
	shell(cmd)

/datum/controller/subsystem/processing/tts/proc/check_processing(client/C)
	if (!C)
		return FALSE

	return (C.ckey in ckeys_playing)

/datum/controller/subsystem/processing/tts/proc/delete_files(datum/tts/T)
	if (!T)
		return
	if (!T.filename)
		return
	fdel(T.filename + ".ogg")
	fdel(T.filename + ".meta")
	STOP_PROCESSING(src, T)
	ckeys_playing -= T.ckey
	qdel(T) // not needed anymore, it can die

/datum/controller/subsystem/processing/tts/proc/play_tts(datum/tts/T)
	T.status = STATUS_PLAYING
	if (!T.owner)
		message_admins("TTS request has no owner")
		delete_files(T)
		return
	if (!T.owner.mob)
		message_admins("TTS request has no mob")
		delete_files(T)
		return

	var/next_channel = open_sound_channel()

	// get length of audio file
	var/audio_length = text2num(file2text(T.filename + ".meta"))
	audio_length = audio_length / 100
	if (!audio_length)
		audio_length = length(T.text)

	if (T.is_global)
		for (var/mob/M in GLOB.player_list)
			if (!(M.client.prefs.hippie_toggles & SOUND_TTS))
				continue

			M.playsound_local(M.loc, T.filename + ".ogg", 100, 0, channel=next_channel)
		addtimer(CALLBACK(src, .proc/delete_files, T), audio_length)
		return
	else
		var/turf/origin = get_turf(T.owner.mob)
		if(!origin)
			message_admins("TTS mob has no loc")
			delete_files(T)
			return
		var/list/listeners = SSmobs.clients_by_zlevel[origin.z]
		listeners = listeners & hearers(world.view, origin)

		T.owner.tts_cooldown = world.time + audio_length

		addtimer(CALLBACK(T.owner.mob, /mob/living.proc/update_tts_hud), audio_length)
		addtimer(CALLBACK(src, .proc/delete_files, T), audio_length)

		for (var/M in listeners)
			var/mob/P = M
			if (!(P.client.prefs.hippie_toggles & SOUND_TTS))
				continue
			if (T.language)
				if (!P.can_speak_in_language(T.language))
					continue

			if (get_dist(P, origin) <= world.view)

				P.playsound_local(origin, T.filename + ".ogg", 100 * T.volume_mod, 0, channel=next_channel)

/datum/tts
	var/client/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/status = STATUS_NEW
	var/datum/language/language
	var/volume_mod = 1
	var/ckey

/datum/tts/process(wait)
	switch(status)
		if(STATUS_NEW)
			var/uid = "[world.time]" + owner.ckey
			fdel(DATA_PATH + "[uid].request")
			fdel(DATA_PATH + "[uid].rlock")

			text2file("", DATA_PATH + "[uid].rlock")
			text2file("name=[uid]\nvoice=[voice]\ntext=[text]", DATA_PATH + "[uid].request")
			fdel(DATA_PATH + "[uid].rlock")

			filename = DATA_PATH + "[uid]"
			SStts.ckeys_playing += ckey
			status = STATUS_GENERATING
		if(STATUS_GENERATING)
			/* Check if this file is ready */
			if (fexists(filename + ".ogg") && fexists(filename + ".meta"))
				SStts.play_tts(src)

/datum/tts/proc/say(client/C, msg, voice = "", is_global = FALSE, volume_mod = 1, datum/language/language)
	if (!C)
		return
	if (!msg)
		return
	owner = C
	ckey = C.ckey
	text = msg
	src.voice = voice
	src.is_global = is_global
	src.volume_mod = volume_mod
	src.language = language

	START_PROCESSING(SStts, src)

/datum/tts/Destroy()
	STOP_PROCESSING(SStts, src)
	return ..()

#undef GENERATOR_PATH
#undef STATUS_NEW
#undef STATUS_GENERATING
#undef STATUS_READY
#undef STATUS_PLAYING