/mob/living/can_speak_vocal(message)
	if(has_trait(TRAIT_MUTE))
		return FALSE

	if(is_muzzled())
		return FALSE

	if(!IsVocal())
		return FALSE

	if(pulledby && pulledby.grab_state == GRAB_KILL)
		return FALSE

	return TRUE
