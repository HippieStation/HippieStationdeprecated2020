/datum/game_mode/blob
	name = "blob"
	config_tag = "blob"
	antag_flag = ROLE_BLOB
	false_report_weight = 5

	required_players = 25
	required_enemies = 1
	recommended_enemies = 2

	announce_span = "green"
	announce_text = "Dangerous gelatinous organisms are spreading throughout the station!\n\
	<span class='green'>Blobs</span>: Consume the station and spread as far as you can.\n\
	<span class='notice'>Crew</span>: Fight back the blobs and minimize station damage."

	var/cores_to_spawn = 1
	var/players_per_core = 22
	var/blob_base_starting_points = 80
	var/list/blob_overminds = list()

/datum/game_mode/blob/pre_setup()
	cores_to_spawn = max(round(num_players()/players_per_core, 1), 1)

	for(var/j = 0, j < cores_to_spawn, j++)
		if (!antag_candidates.len)
			break
		var/datum/mind/blob = pick_n_take(antag_candidates)
		blob_overminds += blob
		blob.assigned_role = "Blob"
		blob.special_role = "Blob"
		log_game("[blob.key] (ckey) has been selected as a Blob")

	if(!blob_overminds.len)
		return FALSE

	return TRUE

/datum/game_mode/blob/post_setup()
	set waitfor = FALSE

	for(var/datum/mind/blob in blob_overminds)
		var/mob/camera/blob/B = blob.current.become_overmind(round(blob_base_starting_points/blob_overminds.len))
		B.mind.name = B.name
		var/turf/T = pick(GLOB.blobstart)
		B.forceMove(T)

	SSshuttle.registerHostileEnvironment(src)

	// Disable the blob event for this round.
	var/datum/round_event_control/blob/B = locate() in SSevents.control
	if(B)
		B.max_occurrences = 0 // disable the event

	. = ..()

/datum/game_mode/blob/generate_report()
	return "A CMP scientist by the name of [pick("Griff", "Pasteur", "Chamberland", "Buist", "Rivers", "Stanley")] boasted about his corporation's \"finest creation\" - a macrobiological \
			virus capable of self-reproduction and hellbent on consuming whatever it touches. He went on to query Cybersun for permission to utilize the virus in biochemical warfare, to which \
			CMP subsequently gained. Be vigilant for any large organisms rapidly spreading across the station, as they are classified as a level 5 biohazard and critically dangerous. Note that \
			this organism seems to be weak to extreme heat; concentrated fire (such as welding tools and lasers) will be effective against it."


/datum/antagonist/blob/greet()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'hippiestation/sound/ambience/antag/blob.ogg',80,0)
