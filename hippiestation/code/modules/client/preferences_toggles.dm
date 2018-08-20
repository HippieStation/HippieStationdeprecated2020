TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggletts)()
	set name = "Hear/Silence Text-to-Speech"
	set category = "Preferences"
	set desc = "Hear Any Text-to-Speech Sounds"
	usr.client.prefs.toggles ^= SOUND_TTS
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_TTS)
		to_chat(usr, "You will now hear any text-to-speech sounds.")
	else
		to_chat(usr, "You will no longer hear text-to-speech sounds.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Hearing Text-to-Speech", "[usr.client.prefs.toggles & SOUND_TTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/togglemidis/Get_checked(client/C)
	return C.prefs.toggles & SOUND_TTS
