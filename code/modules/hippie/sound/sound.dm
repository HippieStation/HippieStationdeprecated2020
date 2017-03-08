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
						continue

					if(source_location && source_location.sound_group && source_location.sound_group != listener_location.sound_group)
						continue

					if(listener_location != source_location)
						S.echo = list(0,0,0,0,0,0,-10000,1.0,1.5,1.0,0,1.0,0,0,0,0,1.0,7) //Sound is occluded
					else
						S.echo = list(0,0,0,0,0,0,0,0.25,1.5,1.0,0,1.0,0,0,0,0,1.0,7)
				S.x = source.x - Mloc.x
				S.z = source.y - Mloc.y //Since sound coordinates are 3D, z for sound falls on y for the map.  BYOND.
				S.y = 0
				S.volume *= attenuate_for_location(Mloc)
				M << S
				S.volume = vol

/mob/proc/playsound_local(var/atom/source, soundin, vol as num, vary, frequency, falloff, surround = 1)
	if(!src.client || src.ear_deaf)
		return
	switch(soundin)
		if ("shatter") soundin = pick(sounds_shatter)
		if ("explosion") soundin = pick(sounds_explosion)
		if ("sparks") soundin = pick(sounds_sparks)
		if ("rustle") soundin = pick(sounds_rustle)
		if ("punch") soundin = pick(sounds_punch)
		if ("clownstep") soundin = pick(sounds_clownstep)
		if ("swing_hit") soundin = pick(sounds_hit)
		if ("hiss") soundin = pick(sounds_hiss)
		if ("pageturn") soundin = pick(sounds_pageturn)
		if ("bodyfall") soundin = pick(sounds_bodyfall)
		if ("gunshot") soundin = pick(sounds_gunshot)
		if ("ricochet") soundin = pick(sounds_ricochet)
		if ("terminal_type") soundin = pick(sounds_terminal)
	if(islist(soundin))
		soundin = pick(soundin)
	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()
	S.volume *= attenuate_for_location(source)
	if(isturf(source))
		var/turf/T = get_turf(src)
		if (surround)
			var/dx = source.x - T.x
			S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)
			var/dz = source.y - T.y
			S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)
	src << S

/proc/generate_sound(var/atom/source, soundin, vol as num, vary, extrarange as num, pitch = 1)
	//Frequency stuff only works with 45kbps oggs.

	switch(soundin)
		if ("shatter") soundin = pick(sounds_shatter)
		if ("explosion") soundin = pick(sounds_explosion)
		if ("sparks") soundin = pick(sounds_sparks)
		if ("rustle") soundin = pick(sounds_rustle)
		if ("punch") soundin = pick(sounds_punch)
		if ("clownstep") soundin = pick(sounds_clownstep)
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
		S = new /sound
		S.file = csound(soundin)
	else if (isfile(soundin))
		S = new /sound
		S.file = soundin
	else if (istype(soundin, /sound))
		S = soundin
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
		S.frequency = get_rand_frequency()
	else
		S.frequency = pitch

	S.volume *= attenuate_for_location(source)

	return S

/*
LEGACY B.S.
*/

/proc/get_rand_frequency()
	return rand(32000, 55000)

/mob/proc/stopLobbySound()
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)
		return
	if(prefs && (prefs.toggles & SOUND_LOBBY))
		src << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS

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