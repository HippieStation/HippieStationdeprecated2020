/datum/game_mode/post_setup()
	..()	//Hopefully all the antags are given their datums at this point
	var/datum/mind/M = var/datum/antagonist/A
	for(M in GLOB.player_list)
		if(!M.has_antag_datum())	//If they have any antag datums then don't give them a crew datum
			M.add_antag_datum(/datum/antagonist/crew)


