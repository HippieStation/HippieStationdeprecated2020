/datum/component/footstep/play_footstep()
	var/mob/living/LM = parent
	var/client/C = LM.client
	if(C)
		if(!(C.prefs.hippie_toggles & SOUND_FOOTSTEPS))
			return
	..()