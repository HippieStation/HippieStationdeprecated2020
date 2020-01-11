/datum/round_event_control/borer
	name = "Borer"
	typepath = /datum/round_event/borer
	weight = 15
	max_occurrences = 0
	min_players = 15
	earliest_start = 6000 // lower start time since borers arent too dangerous

/datum/round_event/borer
	announceWhen = 3000 //Borers get increased time till the crew tries to murder them.
	var/successSpawn = 0

	var/spawncount = 2

/datum/round_event/borer/setup()
	spawncount = rand(2, 4)

/datum/round_event/borer/announce()
	if(successSpawn)
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/ai/aliens.ogg') //Borers seem like normal xenomorphs.


/datum/round_event/borer/start()

	var/list/vents = list()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in GLOB.machines)
		if(QDELETED(temp_vent))
			continue
		if(is_station_level(temp_vent.loc.z) && !temp_vent.welded) //code improvement
			var/datum/pipeline/temp_vent_parent = temp_vent.parents[1] // fixing old shitcode
			if(temp_vent_parent.other_atmosmch.len > 20)
				vents += temp_vent

	if(!vents.len)
		message_admins("An event attempted to spawn a borer, but no suitable vents were found. Shutting down.")
		return MAP_ERROR //code improvement

	var/total_humans = 0
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.stat != DEAD)
			total_humans++

	GLOB.total_borer_hosts_needed = round(1 + total_humans/6)

	while(spawncount >= 1  && vents.len)
		var/obj/vent = pick_n_take(vents)
		new /mob/living/simple_animal/borer(vent.loc)
		successSpawn = TRUE
		spawncount--
		
