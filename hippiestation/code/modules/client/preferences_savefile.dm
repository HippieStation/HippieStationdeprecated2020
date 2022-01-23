// Preferences load
/datum/preferences/proc/hippie_pref_load(savefile/S)
	//toggles
	S["hippie_toggles"] >> hippie_toggles
	hippie_toggles = sanitize_integer(hippie_toggles, 0, 65535, initial(hippie_toggles))

// Preferences save
/datum/preferences/proc/hippie_pref_save(savefile/S)
	//toggles
	WRITE_FILE(S["hippie_toggles"], hippie_toggles)

// Character load
/datum/preferences/proc/hippie_character_pref_load(savefile/S)
	//ipcs
	S["feature_ipc_screen"] >> features["ipc_screen"]
	features["ipc_screen"] 	= sanitize_inlist(features["ipc_screen"], GLOB.ipc_screens_list)

	S["voice"] >> voice
	voice = sanitize_inlist(voice, ((gender == FEMALE) ? splittext(CONFIG_GET(string/tts_voice_female), ",") : splittext(CONFIG_GET(string/tts_voice_male), ",")))
	//gear loadout
	var/text_to_load
	S["loadout"] >> text_to_load
	var/list/saved_loadout_paths = splittext(text_to_load, "|")
	LAZYCLEARLIST(chosen_gear)
	gear_points = initial(gear_points)
	for(var/i in saved_loadout_paths)
		var/datum/gear/path = text2path(i)
		if(path)
			LAZYADD(chosen_gear, path)
			gear_points -= initial(path.cost)

// Character save
/datum/preferences/proc/hippie_character_pref_save(savefile/S)
	//ipcs
	S["feature_ipc_screen"] << features["ipc_screen"]
	S["voice"] << voice
	//gear loadout
	if(islist(chosen_gear))
		if(chosen_gear.len)
			var/text_to_save = chosen_gear.Join("|")
			S["loadout"] << text_to_save
		else
			S["loadout"] << "" //empty string to reset the value
