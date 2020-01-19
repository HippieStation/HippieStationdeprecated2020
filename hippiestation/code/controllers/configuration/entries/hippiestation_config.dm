/datum/config_entry/flag/mentors_mobname_only

/datum/config_entry/string/internet_address_to_use

/datum/config_entry/string/token_generator

/datum/config_entry/string/token_consumer

/datum/config_entry/string/tts_api

/datum/config_entry/flag/mentor_legacy_system	//Defines whether the server uses the legacy mentor system with mentors.txt or the SQL system
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/allow_vote_shuttlecall	// allow shuttle to be called via vote

/datum/config_entry/flag/enable_tts

/datum/config_entry/flag/enable_demo
	protection = CONFIG_ENTRY_LOCKED

// %I is input textfile
// %O is output wavefile
// %V is voice name
/datum/config_entry/string/tts_command
	config_entry_value = "mimic -f \"%I\" -o \"%O\" -voice \"%V\""
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/tts_voice_male
	config_entry_value = "ap,kal,awb,kal16,rms"
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/tts_voice_female
	config_entry_value = "slt"
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/ipstack_api_key
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED

/datum/config_entry/string/auth_provider
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/keyed_list/auth_var
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_TEXT
	protection = CONFIG_ENTRY_LOCKED
