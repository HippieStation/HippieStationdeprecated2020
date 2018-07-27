/datum/station_state
	var/num_territories = 1//Number of total valid territories for gang mode

/datum/station_state/count(count_territories)
	..()
	if(count_territories)
		var/list/valid_territories = list()
		for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION)) //First, collect all area types on the station zlevel
			for(var/ar in SSmapping.areas_in_z["[z]"])
				var/area/A = ar
				if(!(A.type in valid_territories) && A.valid_territory)
					valid_territories |= A.type
		if(valid_territories.len)
			num_territories = valid_territories.len //Add them all up to make the total number of area types