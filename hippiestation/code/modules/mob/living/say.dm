/mob/living/can_speak_vocal(message)
	if(disabilities & MUTE)
		return FALSE

	if(is_muzzled())
		return FALSE

	if(!IsVocal())
		return FALSE

	if(pulledby && pulledby.grab_state == GRAB_KILL)
		return FALSE
		
	return TRUE

/mob/living/say(message, bubble_type,var/list/spans = list(), sanitize = TRUE, datum/language/language = null)
	if(findtext(message, "fart man"))
		to_chat(src, "<span class='boldwarning'>Fucking die.</span>")
		gib()
		playsound_local(get_turf(src), 'hippiestation/sound/misc/slidewhistle_down.ogg', 100, FALSE, pressure_affected = FALSE)
	..()
