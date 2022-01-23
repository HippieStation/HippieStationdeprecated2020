#define TTS_PATH    "tts/"
#define STATUS_NEW			0
#define STATUS_GENERATING	1
#define STATUS_INTERMEDIATE	2
#define STATUS_PLAYING		3

PROCESSING_SUBSYSTEM_DEF(tts)
	name = "Text-to-Speech"
	wait = 2
	runlevels = (RUNLEVEL_LOBBY | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING
	var/list/ckeys_playing = list()// list of ckeys of users currently playing a tts sound

/datum/controller/subsystem/processing/tts/Initialize()
	if (!CONFIG_GET(flag/enable_tts))
		can_fire = FALSE
	for(var/file in flist(TTS_PATH))
		fdel(TTS_PATH + file)
	return ..()

/datum/controller/subsystem/processing/tts/stat_entry()
	..("P:[ckeys_playing.len]")

/datum/controller/subsystem/processing/tts/proc/check_processing(client/C)
	if (!C)
		return FALSE

	return (C.ckey in ckeys_playing)

/datum/controller/subsystem/processing/tts/proc/terminate(datum/tts/T)
	if (QDELETED(T))
		return
	STOP_PROCESSING(src, T)
	ckeys_playing -= T.ckey
	qdel(T) // not needed anymore, it can die

/datum/controller/subsystem/processing/tts/proc/play_tts(datum/tts/T)
	T.status = STATUS_PLAYING
	if (!T.owner)
		message_admins("TTS request has no owner")
		terminate(T)
		return
	if (!T.owner.mob)
		message_admins("TTS request has no mob")
		terminate(T)
		return
	if(!(T.voice in splittext(CONFIG_GET(string/tts_voice_male), ",")) && !(T.voice in splittext(CONFIG_GET(string/tts_voice_female), ",")) && T.voice != "")
		message_admins("TTS request has invalid voice")
		terminate(T)
		return

	var/next_channel = open_sound_channel()

	if (T.is_global)
		for (var/mob/M in GLOB.player_list)
			if (!(M.client.prefs.hippie_toggles & SOUND_TTS))
				continue
			M.playsound_local(M.loc, TTS_PATH +  "[T.filename].wav", 100, 0, channel=next_channel)
		addtimer(CALLBACK(src, .proc/terminate, T), T.length)
		return
	else
		var/turf/origin = get_turf(T.owner.mob)
		if(!origin)
			message_admins("TTS mob has no loc")
			terminate(T)
			return
		var/list/listeners = SSmobs.clients_by_zlevel[origin.z]
		listeners = listeners & hearers(world.view, origin)
		if(T.owner.mob && T.owner.mob.loc != origin)
			for(var/mob/living/L in T.owner.mob.loc)
				listeners |= L
		for(var/mob/dead/observer/O in range(world.view, origin))
			listeners |= O

		T.owner.tts_cooldown = world.time + T.length

		addtimer(CALLBACK(T.owner.mob, /mob/living.proc/update_tts_hud), T.length + 5)
		addtimer(CALLBACK(src, .proc/terminate, T), T.length)

		for (var/M in listeners)
			var/mob/P = M
			if (!(P.client.prefs.hippie_toggles & SOUND_TTS))
				continue
			if (T.language)
				if (!P.can_speak_in_language(T.language) && !isobserver(P))
					continue
			if (get_dist(P, origin) <= world.view)
				P.playsound_local(origin, TTS_PATH +  "[T.filename].wav", 100 * T.volume_mod, 0, channel=next_channel)

/datum/tts
	var/client/owner
	var/text = ""
	var/voice = ""
	var/filename = ""
	var/is_global = FALSE
	var/status = STATUS_NEW
	var/datum/language/language
	var/volume_mod = 1
	var/length = 1
	var/ckey

/datum/tts/process(wait)
	switch(status)
		if(STATUS_NEW)
			status = STATUS_INTERMEDIATE // the purpose of STATUS_INTERMEDIATE is to prevent the next process from playing the sound before it was generated
			filename = md5("[world.time][owner.ckey][text][voice]")
			if(fexists(TTS_PATH + "[filename].lock"))
				qdel(src)
				return
			text2file("", TTS_PATH + "[filename].lock")
			text2file(text, TTS_PATH + "[filename].txt")

			SStts.ckeys_playing += ckey
			var/command = CONFIG_GET(string/tts_command)
			command = replacetext(command, "%I", TTS_PATH + "[filename].txt")
			command = replacetext(command, "%O", TTS_PATH + "[filename].wav")
			command = replacetext(command, "%V", voice)
			var/list/output = world.shelleo(command)
			var/errorlevel = output[SHELLEO_ERRORLEVEL]
			if(errorlevel)
				SStts.terminate(src)
				return
			output = world.shelleo("mediainfo --Inform=\"General;%Duration%\" \"[TTS_PATH][filename].wav\"")
			errorlevel = output[SHELLEO_ERRORLEVEL]
			var/stdout = output[SHELLEO_STDOUT]
			if(errorlevel || !stdout || !length(stdout))
				length = 10 SECONDS // ugh
			else
				length = text2num(stdout) * 0.01 // it outputs in ms. we want ds.
			status = STATUS_GENERATING
		if(STATUS_GENERATING)
			if (fexists(TTS_PATH + "[filename].wav"))
				SStts.play_tts(src)

/datum/tts/proc/say(client/C, msg, voice = "", is_global = FALSE, volume_mod = 1, datum/language/language)
	if (!C)
		return
	if (!msg)
		return
	src.owner = C
	src.ckey = C.ckey
	src.text = msg
	src.voice = voice
	src.is_global = is_global
	src.volume_mod = volume_mod
	src.language = language

	START_PROCESSING(SStts, src)

/datum/tts/Destroy()
	STOP_PROCESSING(SStts, src)
	return ..()

#undef TTS_PATH
#undef STATUS_NEW
#undef STATUS_GENERATING
#undef STATUS_PLAYING
