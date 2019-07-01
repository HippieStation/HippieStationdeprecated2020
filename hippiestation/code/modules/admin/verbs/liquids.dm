/client/proc/make_liquid()
	set name = "Spawn Liquid Pool"
	set category = "Fun"
	set desc = "Spawn A Liquid Pool"
	var/chosen_id
	switch(alert(usr, "Choose a method.", "Add Reagents", "Search", "Choose from a list", "I'm feeling lucky"))
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
	var/amount = input(usr, "Choose the amount to add.", "Choose the amount.", 1000) as num
	if(!amount)
		return
	var/turf/T = get_turf(usr)
	message_admins("[key_name(src)] has created a pool of '[chosen_id]' liquid, with a volume of [amount]u, at [COORD(T)].")
	log_game("[key_name(src)] has created a pool of '[chosen_id]' liquid, with a volume of [amount]u, at [COORD(T)].")

	var/obj/effect/liquid/W = new /obj/effect/liquid(T)
	W.reagents.maximum_volume = max(W.reagents.maximum_volume, amount)
	W.reagents.add_reagent(chosen_id, amount)
	W.depth = max(amount / REAGENT_TO_DEPTH, 0)
	if(W.depth <= 0)
		return
	W.update_depth()
	INVOKE_ASYNC(W, /obj/effect/liquid.proc/equilibrate)
