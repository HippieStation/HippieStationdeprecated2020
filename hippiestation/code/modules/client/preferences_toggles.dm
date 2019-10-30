TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggletts)()
	set name = "Hear/Silence Text-to-Speech"
	set category = "Preferences"
	set desc = "Hear Any Text-to-Speech Sounds"
	usr.client.prefs.hippie_toggles ^= SOUND_TTS
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.hippie_toggles & SOUND_TTS)
		to_chat(usr, "You will now hear any text-to-speech sounds.")
	else
		to_chat(usr, "You will no longer hear text-to-speech sounds.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Hearing Text-to-Speech", "[usr.client.prefs.toggles & SOUND_TTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/verbs/menu/Settings/Sound/toggletts/Get_checked(client/C)
	return C.prefs.hippie_toggles & SOUND_TTS

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_footsteps)()
	set name = "Hear/Silence Footsteps"
	set category = "Preferences"
	set desc = "Hear In-game Footsteps"
	usr.client.prefs.hippie_toggles ^= SOUND_FOOTSTEPS
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.hippie_toggles & SOUND_FOOTSTEPS)
		to_chat(usr, "You will now hear people's footsteps.")
	else
		to_chat(usr, "You will no longer hear people's footsteps.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Footsteps", "[usr.client.prefs.toggles & SOUND_FOOTSTEPS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_footsteps/Get_checked(client/C)
	return C.prefs.hippie_toggles & SOUND_FOOTSTEPS

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_vox)()
	set name = "Hear/Silence AI VOX"
	set category = "Preferences"
	set desc = "Hear AI VOX"
	usr.client.prefs.hippie_toggles ^= SOUND_VOX
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.hippie_toggles & SOUND_VOX)
		to_chat(usr, "You will now hear AI VOX.")
	else
		to_chat(usr, "You will no longer hear AI VOX.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle AI VOX", "[usr.client.prefs.hippie_toggles & SOUND_VOX ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/verbs/menu/Settings/Sound/toggle_vox/Get_checked(client/C)
	return C.prefs.hippie_toggles & SOUND_VOX
