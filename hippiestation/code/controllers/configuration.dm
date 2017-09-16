/datum/configuration
	var/mentors_mobname_only = 0	// Only display mob name to mentors in mentorhelps
	var/internet_address_to_use = null
	var/token_generator = null
	var/token_consumer = null

	var/list/malf_chance = list()

//Here we can load hippie specific config settings.
//They go in config/hippiestation_config.txt
/proc/load_hippie_config(filename, type = "config")
	var/list/Lines = world.file2list(filename)
	var/list/modes = list()

	var/list/gamemode_cache = typecacheof(/datum/game_mode,TRUE)
	for(var/T in gamemode_cache)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if(M.config_tag)
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				modes += M.config_tag
		qdel(M)

	for(var/t in Lines)
		if(!t)
			continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue

		if(type == "config") //Add new config options here.
			switch(name)
				if ("mentor_mobname_only")
					config.mentors_mobname_only = 1
				if ("internet_address_to_use")
					config.internet_address_to_use = value
				if ("token_generator")
					config.token_generator = value
				if ("token_consumer")
					config.token_consumer = value
				if ("malf_chance")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if(prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if(prob_name in modes)
							config.malf_chance[prob_name] = text2num(prob_value)
						else
							WRITE_FILE(GLOB.config_error_log, "Unknown malf probability configuration definition: [prob_name].")
					else
						WRITE_FILE(GLOB.config_error_log, "Incorrect malf configuration definition: [prob_name]  [prob_value].")
		else
			GLOB.world_game_log << "Unknown setting in configuration: '[name]'"
