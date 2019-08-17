///Allows rounds to basically be "rerolled" should the initial premise fall through. Also known as mulligan antags.
/datum/game_mode/proc/convert_roundtype()
	set waitfor = FALSE
	var/list/living_crew = list()

	for(var/mob/Player in GLOB.mob_list)
		if(Player.mind && Player.stat != DEAD && !isnewplayer(Player) && !isbrain(Player) && Player.client)
			living_crew += Player
	var/malc = CONFIG_GET(number/midround_antag_life_check)
	if(living_crew.len / GLOB.joined_player_list.len <= malc) //If a lot of the player base died, we start fresh
		message_admins("Convert_roundtype failed due to too many dead people. Limit is [malc * 100]% living crew")
		return null

	var/list/datum/game_mode/runnable_modes = config.get_runnable_midround_modes(living_crew.len)
	var/list/datum/game_mode/usable_modes = list()
	for(var/datum/game_mode/G in runnable_modes)
		if(G.reroll_friendly && living_crew.len >= G.required_players)
			usable_modes += G
		else
			qdel(G)

	if(!usable_modes.len)
		message_admins("Convert_roundtype failed due to no valid modes to convert to. Please report this error to the Coders.")
		return null

	replacementmode = pickweight(usable_modes)

	switch(SSshuttle.emergency.mode) //Rounds on the verge of ending don't get new antags, they just run out
		if(SHUTTLE_STRANDED, SHUTTLE_ESCAPE, SHUTTLE_DISABLED) //MODULE: SHUTTLE TOGGLE
			return 1
		if(SHUTTLE_CALL)
			if(SSshuttle.emergency.timeLeft(1) < initial(SSshuttle.emergencyCallTime)*0.5)
				return 1

	var/matc = CONFIG_GET(number/midround_antag_time_check)
	if(world.time >= (matc * 600))
		message_admins("Convert_roundtype failed due to round length. Limit is [matc] minutes.")
		return null

	var/list/antag_candidates = list()

	for(var/mob/living/carbon/human/H in living_crew)
		if(H.client && H.client.prefs.allow_midround_antag && !is_centcom_level(H.z))
			if(!is_banned_from(H.ckey, CATBAN) && !is_banned_from(H.ckey, CLUWNEBAN) && !is_banned_from(H.ckey, CRABBAN) && !HAS_TRAIT(H, TRAIT_MINDSHIELD)) // hippie -- adds our jobban checks, cockblocks mindshielded people
				antag_candidates += H

	if(!antag_candidates)
		message_admins("Convert_roundtype failed due to no antag candidates.")
		return null

	antag_candidates = shuffle(antag_candidates)

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		replacementmode.restricted_jobs += replacementmode.protected_jobs
	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		replacementmode.restricted_jobs += "Assistant"

	message_admins("The roundtype will be converted. If you have other plans for the station or feel the station is too messed up to inhabit <A HREF='?_src_=holder;[HrefToken()];toggle_midround_antag=[REF(usr)]'>stop the creation of antags</A> or <A HREF='?_src_=holder;[HrefToken()];end_round=[REF(usr)]'>end the round now</A>.")
	log_game("Roundtype converted to [replacementmode.name]")

	. = 1

	sleep(rand(600,1800))
	if(!SSticker.IsRoundInProgress())
		message_admins("Roundtype conversion cancelled, the game appears to have finished!")
		round_converted = 0
		return
	 //somewhere between 1 and 3 minutes from now
	if(!CONFIG_GET(keyed_list/midround_antag)[SSticker.mode.config_tag])
		round_converted = 0
		return 1
	for(var/mob/living/carbon/human/H in antag_candidates)
		if(H.client)
			replacementmode.make_antag_chance(H)
	replacementmode.gamemode_ready = TRUE //Awful but we're not doing standard setup here.
	round_converted = 2
	message_admins("-- IMPORTANT: The roundtype has been converted to [replacementmode.name], antagonists may have been created! --")
