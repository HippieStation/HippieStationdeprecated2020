/*
 * This sound system was based off the sound.dm found in the public Goonstation release
 * https://github.com/goonstation/goonstation-2016/blob/d8a2d60915fd3b74653a1b7d4b8a0910c6fc2f19/code/sound.dm
 */

// returns 0 to 1
/proc/attenuate_for_location(var/atom/loc)
	var/attenuate = 1
	var/turf/T = get_turf(loc)
	if (istype(T, /turf/open/space))
		return 0 // in space nobody can hear you fart
	var/turf/open/sim_T = T
	if (istype(sim_T) && sim_T.air)
		attenuate *= sim_T.air.return_pressure() / ONE_ATMOSPHERE
		attenuate = min(1, max(0, attenuate))

	return attenuate

/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch)
	if (!limiter || !limiter.canISpawn(/sound))
		return
	var/area/source_location = get_area(source)
	vol *= attenuate_for_location(source)
	var/source_location_root = null
	if(source_location)
		source_location_root = get_top_ancestor(source_location, /area)

	var/sound/S = generate_sound(source, soundin, vol, vary, extrarange, pitch)
	if(S && source)
		for (var/P in player_list)
			var/mob/M = P
			if(isliving(M))
				var/mob/living/L = M
				if (L.hallucination)
					S.environment = SOUND_ENVIRONMENT_PSYCHOTIC
				else if (L.druggy)
					S.environment = SOUND_ENVIRONMENT_DRUGGED
				else if (L.drowsyness)
					S.environment = SOUND_ENVIRONMENT_DIZZY
				else if (L.confused)
					S.environment = SOUND_ENVIRONMENT_DIZZY
				else if (L.sleeping)
					S.environment = SOUND_ENVIRONMENT_UNDERWATER
			var/turf/Mloc = get_turf(M)
			if(!isnull(Mloc) && M.client && source && Mloc.z == source.z)
				var/area/listener_location = get_area(Mloc)
				if(listener_location)
					var/listener_location_root = get_top_ancestor(listener_location, /area)
					if(listener_location_root != source_location_root && !(listener_location != /area && source_location != /area))
						//boutput(M, "You did not hear a [source] at [source_location]!")
						continue

					if(source_location && source_location.sound_group && source_location.sound_group != listener_location.sound_group)
						//boutput(M, "You did not hear a [source] at [source_location] due to the sound_group ([source_location.sound_group]) not matching yours ([listener_location.sound_group])")
						continue

					if(listener_location != source_location)
						//boutput(M, "You barely hear a [source] at [source_location]!")
						S.echo = list(0,0,0,0,0,0,-10000,1.0,1.5,1.0,0,1.0,0,0,0,0,1.0,7) //Sound is occluded
					else
						//boutput(M, "You hear a [source] at [source_location]!")
						S.echo = list(0,0,0,0,0,0,0,0.25,1.5,1.0,0,1.0,0,0,0,0,1.0,7)
				//if(get_dist(M, source) >= 30) return // hard attentuation i guess
				S.x = source.x - Mloc.x
				S.z = source.y - Mloc.y //Since sound coordinates are 3D, z for sound falls on y for the map.  BYOND.
				S.y = 0
				S.volume *= attenuate_for_location(Mloc)
				M << S
				S.volume = vol

		//pool(S)

/atom/proc/playsound_local(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch = 1)

	switch(soundin)
		if ("shatter") soundin = pick(sounds_shatter)
		if ("explosion") soundin = pick(sounds_explosion)
		if ("sparks") soundin = pick(sounds_sparks)
		if ("rustle") soundin = pick(sounds_rustle)
		if ("punch") soundin = pick(sounds_punch)
		if ("clownstep") soundin = pick(sounds_clown)
		if ("swing_hit") soundin = pick(sounds_hit)
		if ("hiss") soundin = pick(sounds_hiss)
		if ("pageturn") soundin = pick(sounds_pageturn)
		if ("bodyfall") soundin = pick(sounds_bodyfall)
		if ("gunshot") soundin = pick(sounds_gunshot)
		if ("ricochet") soundin = pick(sounds_ricochet)
		if ("terminal_type") soundin = pick(sounds_terminal)

	if(islist(soundin))
		soundin = pick(soundin)

	var/sound/S
	if(istext(soundin))
		S = unpool(/sound)
		S.file = csound(soundin)
		//DEBUG("Created sound [S.file] from csound - soundin is text([soundin])")
	else if (isfile(soundin))
		S = unpool(/sound)
		S.file = soundin// = sound(soundin)
		//DEBUG("Created sound [S.file] from file - soundin is file")
	else if (istype(soundin, /sound))
		S = soundin
		//DEBUG("Used input sound: [S.file]")

	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol * attenuate_for_location(src)
	S.priority = 5

	if (vary)
		S.frequency = rand(725, 1250) / 1000 * pitch
	else
		S.frequency = pitch

	if(isturf(source))
		var/dx = source.x - src.x
		S.pan = max(-100, min(100, dx/8.0 * 100))
	src << S
	//pool(S)


/proc/generate_sound(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch = 1)
	//Frequency stuff only works with 45kbps oggs.

	switch(soundin)
		if ("shatter") soundin = pick(sounds_shatter)
		if ("explosion") soundin = pick(sounds_explosion)
		if ("sparks") soundin = pick(sounds_sparks)
		if ("rustle") soundin = pick(sounds_rustle)
		if ("punch") soundin = pick(sounds_punch)
		if ("clownstep") soundin = pick(sounds_clown)
		if ("swing_hit") soundin = pick(sounds_hit)
		if ("hiss") soundin = pick(sounds_hiss)
		if ("pageturn") soundin = pick(sounds_pageturn)
		if ("bodyfall") soundin = pick(sounds_bodyfall)
		if ("gunshot") soundin = pick(sounds_gunshot)
		if ("ricochet") soundin = pick(sounds_ricochet)
		if ("terminal_type") soundin = pick(sounds_terminal)

	if(islist(soundin))
		soundin = pick(soundin)

	var/sound/S
	if(istext(soundin))
		S = unpool(/sound)
		S.file = csound(soundin)
		//DEBUG("Created sound [S.file] from csound - soundin is text([soundin])")
	else if (isfile(soundin))
		S = unpool(/sound)
		S.file = soundin// = sound(soundin)
		//DEBUG("Created sound [S.file] from file - soundin is file")
	else if (istype(soundin, /sound))
		S = soundin
		//DEBUG("Used input sound: [S.file]")

	/*
	var/sound/S
	if(istext(soundin))
		S = unpool(/sound)
		S.file = csound(soundin)
	else
		S = sound(soundin)

	*/
	S.falloff = (world.view + extrarange)/10
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	S.priority = 5
	S.environment = 0

	var/location = null
	if(source) //runtime error fix
		location = source.loc
	if(location != null && isturf(location))
		var/turf/T = location
		location = T.loc
	if(location != null && isarea(location))
		var/area/A = location
		S.environment = A.sound_environment

	if (vary)
		S.frequency = rand(725, 1250) / 1000 * pitch
	else
		S.frequency = pitch

	S.volume *= attenuate_for_location(source)

	return S

/// pool of precached sounds

/var/global/list/sounds_shatter = list(sound('sound/effects/Glassbr1.ogg'),sound('sound/effects/Glassbr2.ogg'),sound('sound/effects/Glassbr3.ogg'))
/var/global/list/sounds_explosion = list(sound('sound/effects/Explosion1.ogg'),sound('sound/effects/Explosion2.ogg'))
/var/global/list/sounds_sparks = list(sound('sound/effects/sparks1.ogg'),sound('sound/effects/sparks2.ogg'),sound('sound/effects/sparks3.ogg'),sound('sound/effects/sparks4.ogg'))
/var/global/list/sounds_rustle = list(sound('sound/effects/rustle1.ogg'),sound('sound/effects/rustle2.ogg'),sound('sound/effects/rustle3.ogg'),sound('sound/effects/rustle4.ogg'),sound('sound/effects/rustle5.ogg'))
/var/global/list/sounds_punch = list(sound('sound/weapons/punch1.ogg'),sound('sound/weapons/punch2.ogg'),sound('sound/weapons/punch3.ogg'),sound('sound/weapons/punch4.ogg'))
/var/global/list/sounds_clown = list(sound('sound/effects/clownstep1.ogg'),sound('sound/effects/clownstep2.ogg'))
/var/global/list/sounds_hit = list(sound('sound/weapons/genhit1.ogg'),sound('sound/weapons/genhit2.ogg'),sound('sound/weapons/genhit3.ogg'))
/var/global/list/sounds_gunshot = list(sound('sound/weapons/Gunshot.ogg'),sound('sound/weapons/Gunshot2.ogg'),sound('sound/weapons/Gunshot3.ogg'),sound('sound/weapons/Gunshot4.ogg'))
/var/global/list/sounds_terminal = list(sound('sound/machines/terminal_button01.ogg'),sound('sound/machines/terminal_button02.ogg'), sound('sound/machines/terminal_button03.ogg'),sound('sound/machines/terminal_button04.ogg'), sound('sound/machines/terminal_button05.ogg'), sound('sound/machines/terminal_button06.ogg'),sound('sound/machines/terminal_button07.ogg'), sound('sound/machines/terminal_button08.ogg'))
/var/global/list/sounds_hiss = list(sound('sound/voice/hiss1.ogg'),sound('sound/voice/hiss2.ogg'),sound('sound/voice/hiss3.ogg'),sound('sound/voice/hiss4.ogg'))
/var/global/list/sounds_pageturn = list(sound('sound/effects/pageturn1.ogg'),sound('sound/effects/pageturn2.ogg'),sound('sound/effects/pageturn3.ogg'))
/var/global/list/sounds_ricochet = list(sound('sound/weapons/effects/ric1.ogg'),sound('sound/weapons/effects/ric2.ogg'),sound('sound/weapons/effects/ric3.ogg'),sound('sound/weapons/effects/ric4.ogg'),sound('sound/weapons/effects/ric5.ogg'))
/var/global/list/sounds_bodyfall = list(sound('sound/effects/bodyfall1.ogg'),sound('sound/effects/bodyfall2.ogg'),sound('sound/effects/bodyfall3.ogg'),sound('sound/effects/bodyfall4.ogg'))

/*
LEGACY B.S.
*/

/proc/get_rand_frequency()
	return rand(32000, 55000)

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(sounds_shatter)
			if ("explosion") soundin = pick(sounds_explosion)
			if ("sparks") soundin = pick(sounds_sparks)
			if ("rustle") soundin = pick(sounds_rustle)
			if ("punch") soundin = pick(sounds_punch)
			if ("clownstep") soundin = pick(sounds_clown)
			if ("swing_hit") soundin = pick(sounds_hit)
			if ("hiss") soundin = pick(sounds_hiss)
			if ("pageturn") soundin = pick(sounds_pageturn)
			if ("bodyfall") soundin = pick(sounds_bodyfall)
			if ("gunshot") soundin = pick(sounds_gunshot)
			if ("ricochet") soundin = pick(sounds_ricochet)
			if ("terminal_type") soundin = pick(sounds_terminal)

/mob/proc/stopLobbySound()
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)
		return
	if(prefs && (prefs.toggles & SOUND_LOBBY))
		src << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS

/mob/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1)
	if(!client || ear_deaf > 0)
		return
	..()

/proc/playsound_global(file, repeat=0, wait, channel, volume)
	for(var/V in clients)
		V << sound(file, repeat, wait, channel, volume)

/**
 * Soundcache
 * NEVER use these sounds for modifying.
 * This should only be used for sounds that are played unaltered to the user.
 * @param text name the name of the sound that will be returned
 * @return sound
 */
/proc/csound(var/name)
	return sound_cache[name]

sound
	Del()
		// Haha you cant delete me you fuck
		if(!qdeled)
			pool(src)
		else
			//Yes I can
			..()
		return

	unpooled()
		file = initial(file)
		repeat = initial(repeat)
		wait = initial(wait)
		channel = initial(channel)
		volume = initial(volume)
		frequency = initial(frequency)
		pan = initial(pan)
		priority = initial(priority)
		status = initial(status)
		x = initial(x)
		y = initial(y)
		z = initial(z)
		falloff = initial(falloff)
		environment = initial(environment)
		echo = initial(echo)

/proc/get_top_ancestor(var/datum/object, var/ancestor_of_ancestor=/datum)
	if(!object || !ancestor_of_ancestor)
		CRASH("Null value parameters in get top ancestor.")
	if(!ispath(ancestor_of_ancestor))
		CRASH("Non-Path ancestor of ancestor parameter supplied.")
	var/stringancestor = "[ancestor_of_ancestor]"
	var/stringtype = "[object.type]"
	var/ancestorposition = findtextEx(stringtype, stringancestor)
	if(!ancestorposition)
		return null
	var/parentstart = ancestorposition + length(stringancestor) + 1
	var/parentend = findtextEx(stringtype, "/", parentstart)
	var/stringtarget = copytext(stringtype, 1, parentend ? parentend : 0)
	return text2path(stringtarget)