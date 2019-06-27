/client/proc/space_liquid()
	set name = "Make Space Into Liquid"
	set category = "Fun"
	set desc = "Turns space into a liquid!"
	var/chosen_id
	switch(alert(usr, "Choose a method.", "Add Reagents", "Enter ID", "Choose ID", "Clear Reagent"))
		if("Search")
			var/valid_id
			while(!valid_id)
				chosen_id = input(usr, "Enter the ID of the reagent you want to add.", "Search reagents") as null|text
				if(!chosen_id)
					return
				if (!ispath(text2path(chosen_id)))
					chosen_id = pick_closest_path(chosen_id, make_types_fancy(subtypesof(/datum/reagent)))
					if (ispath(chosen_id))
						valid_id = TRUE
				else
					valid_id = TRUE
				if(!valid_id)
					to_chat(usr, "<span class='warning'>A reagent with that ID doesn't exist!</span>")
		if("Choose from a list")
			chosen_id = input(usr, "Choose a reagent to add.", "Choose a reagent.") as null|anything in subtypesof(/datum/reagent)
			if(!chosen_id)
				return
		if("I'm feeling lucky")
			chosen_id = pick(subtypesof(/datum/reagent))
		if("Clear Reagent")
			GLOB.space_reagent = null
			message_admins("[key_name(src)] has un-liquified space.")
			log_game("[key_name(src)] has un-liquified space.")
			change_parallax_colors(null)
			for(var/turf/open/space/S in world)
				STOP_PROCESSING(SSprocessing, S)
			return
	message_admins("[key_name(src)] has turned space into '[chosen_id]' liquid.")
	log_game("[key_name(src)] has turned space into '[chosen_id]' liquid.")
	GLOB.space_reagent = chosen_id
	var/datum/reagent/R = GLOB.chemical_reagents_list[chosen_id]
	if(R && R.color)
		change_parallax_colors(R.color)
	for(var/turf/open/space/S in world)
		//if(S.is_actually_next_to_something())
		if(is_station_level(S.z))
			START_PROCESSING(SSprocessing, S)

/proc/change_parallax_colors(color)
	for(var/client/C in GLOB.clients)
		for(var/thing in C.parallax_layers)
			var/obj/screen/parallax_layer/L = thing
			L.color = color
