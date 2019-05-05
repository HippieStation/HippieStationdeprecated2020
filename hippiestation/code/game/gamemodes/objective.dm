/datum/objective/steal/check_completion()
	. = ..()
	var/list/ok_areas = list(/area/hippie/infiltrator_base, /area/syndicate_mothership, /area/shuttle/hippie/stealthcruiser)
	var/list/compiled_areas = list()
	for(var/A in ok_areas)
		compiled_areas += typesof(A)
	for(var/A in compiled_areas)
		var/area/AR = locate(A) in GLOB.sortedAreas
		if(AR)
			for(var/obj/item/I in AR.GetAllContents()) //Check for items
				if(istype(I, steal_target))
					if(!targetinfo) //If there's no targetinfo, then that means it was a custom objective. At this point, we know you have the item, so return 1.
						return TRUE
					else if(targetinfo.check_special_completion(I))//Returns 1 by default. Items with special checks will return 1 if the conditions are fulfilled.
						return TRUE
				if(targetinfo && (I.type in targetinfo.altitems)) //Ok, so you don't have the item. Do you have an alternative, at least?
					if(targetinfo.check_special_completion(I))//Yeah, we do! Don't return 0 if we don't though - then you could fail if you had 1 item that didn't pass and got checked first!
						return TRUE
				CHECK_TICK
	CHECK_TICK

/datum/objective/give_special_equipment(special_equipment)
	if(istype(team, /datum/team/infiltrator))
		for(var/eq_path in special_equipment)
			if(eq_path)
				for(var/turf/T in GLOB.infiltrator_objective_items)
					if(!(eq_path in T.contents))
						new eq_path(T)
	else
		..()


/datum/objective/steal/kotd
	martyr_compatible = FALSE
	targetinfo = new/datum/objective_item/steal/kotd
	steal_target = /obj/item/disk/nuclear
	explanation_text = "Survive the round with the Nuclear Authentication Disk in your possession, or escape with more telecrystals than any other traitor. Holding the disk grants you one additional telecrystal per minute. Be warned, other traitors are also after the disk."


/datum/objective/steal/kotd/check_completion()
	var/datum/component/uplink/O = owner.find_syndicate_uplink()
	if(!considered_escaped(owner))
		return FALSE
	if(O)
		var/leader = TRUE
		for(var/mob/living/player in GLOB.antagonists)
			if(!player.mind || !player.mind.has_antag_datum(ANTAG_DATUM_KOTD))
				continue
			if(player.mind == owner)
				continue
			if(!considered_escaped(player.mind))
				continue
			var/datum/component/uplink/U = player.mind.find_syndicate_uplink()
			if(O.telecrystals < U.telecrystals) // Checks to see if anybody has more TC than you and is also on centcom
				leader = FALSE
		if(leader) // If you have more TC than anybody else and get to centcom, you greentext, otherwise it checks to see if you have the disk.
			return TRUE
	//Disk check, since we're a steal objective using the parent proc is fine
	return ..()
