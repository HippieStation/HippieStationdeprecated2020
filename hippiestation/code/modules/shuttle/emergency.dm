#define TIME_LEFT (SSshuttle.emergency.timeLeft())
#define ENGINES_START_TIME 100
#define ENGINES_STARTED (SSshuttle.emergency.mode == SHUTTLE_IGNITING)
#define IS_DOCKED (SSshuttle.emergency.mode == SHUTTLE_DOCKED || (ENGINES_STARTED))

/obj/item/storage/pod/can_interact(mob/user)
	return TRUE

/obj/machinery/computer/emergency_shuttle
	var/list/last_action = list() // hippie -- kill shuttle auth spam

/obj/machinery/computer/emergency_shuttle/emag_act(mob/user)
	// How did you even get on the shuttle before it go to the station?
	if(!IS_DOCKED)
		return

	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED) //Shuttle disable check
		return

	if(CHECK_BITFIELD(obj_flags, EMAGGED) || ENGINES_STARTED)	//SYSTEM ERROR: THE SHUTTLE WILL LA-SYSTEM ERROR: THE SHUTTLE WILL LA-SYSTEM ERROR: THE SHUTTLE WILL LAUNCH IN 10 SECONDS
		to_chat(user, "<span class='warning'>The shuttle is already about to launch!</span>")
		return

	var/time = TIME_LEFT
	message_admins("[ADMIN_LOOKUPFLW(user.client)] has emagged the emergency shuttle [time] seconds before launch.")
	log_game("[key_name(user)] has emagged the emergency shuttle in [COORD(src)] [time] seconds before launch.")

	ENABLE_BITFIELD(obj_flags, EMAGGED)
	SSshuttle.emergency.movement_force = list("KNOCKDOWN" = 60, "THROW" = 20)//YOUR PUNY SEATBELTS can SAVE YOU NOW, MORTAL
	var/datum/species/S = new
	for(var/i in 1 to 10)
		// the shuttle system doesn't know who these people are, but they
		// must be important, surely
		var/obj/item/card/id/ID = new(src)
		var/datum/job/J = pick(SSjob.occupations)
		ID.registered_name = S.random_name(pick(MALE, FEMALE))
		ID.assignment = J.title

		authorized += ID

	process()

/obj/docking_port/mobile/emergency/request(obj/docking_port/stationary/S, area/signalOrigin, reason, redAlert, set_coefficient=null)
	if(mode == SHUTTLE_DISABLED) //Shuttle disable check
		return

	if(!isnum(set_coefficient))
		var/security_num = seclevel2num(get_security_level())
		switch(security_num)
			if(SEC_LEVEL_GREEN)
				set_coefficient = 2
			if(SEC_LEVEL_BLUE)
				set_coefficient = 1
			else
				set_coefficient = 0.5
	var/call_time = SSshuttle.emergencyCallTime * set_coefficient * engine_coeff
	switch(mode)
		// The shuttle can not normally be called while "recalling", so
		// if this proc is called, it's via admin fiat
		if(SHUTTLE_RECALL, SHUTTLE_IDLE, SHUTTLE_CALL)
			mode = SHUTTLE_CALL
			setTimer(call_time)
		else
			return

	SSshuttle.emergencyCallAmount++

	if(prob(70))
		SSshuttle.emergencyLastCallLoc = signalOrigin
	else
		SSshuttle.emergencyLastCallLoc = null
	var/callsound = pick(pyko_call)

	priority_announce("The emergency shuttle has been called. [redAlert ? "Red Alert state confirmed: Dispatching priority shuttle. " : "" ]It will arrive in [timeLeft(600)] minutes.[reason][SSshuttle.emergencyLastCallLoc ? "\n\nCall signal traced. Results can be viewed on any communications console." : "" ] [SSshuttle.adminEmergencyNoRecall ? "\n\nWarning: Shuttle recall subroutines disabled; Recall not possible." : ""]", null, callsound, "Priority")//Shuttle disable check
	reason = copytext(reason, 1, 100)

/obj/docking_port/mobile/emergency/cancel(area/signalOrigin)
	if(SSshuttle.adminEmergencyNoRecall)//No recall check
		return

	if(mode != SHUTTLE_CALL)
		return

	if(SSshuttle.emergencyNoRecall)
		return

	invertTimer()
	mode = SHUTTLE_RECALL

	if(prob(70))
		SSshuttle.emergencyLastCallLoc = signalOrigin
	else
		SSshuttle.emergencyLastCallLoc = null
	var/recallsound = pick(pyko_recall)
	priority_announce("The emergency shuttle has been recalled.[SSshuttle.emergencyLastCallLoc ? " Recall signal traced. Results can be viewed on any communications console." : "" ]", null, recallsound, "Priority")

/obj/docking_port/mobile/emergency/check()
	if(!timer)
		return
	var/time_left = timeLeft(1)

	// The emergency shuttle doesn't work like others so this
	// ripple check is slightly different
	if(!ripples.len && (time_left <= SHUTTLE_RIPPLE_TIME) && ((mode == SHUTTLE_CALL) || (mode == SHUTTLE_ESCAPE)))
		var/destination
		if(mode == SHUTTLE_CALL)
			destination = SSshuttle.getDock("emergency_home")
		else if(mode == SHUTTLE_ESCAPE)
			destination = SSshuttle.getDock("emergency_away")
		create_ripples(destination)

	switch(mode)
		if(SHUTTLE_RECALL)
			if(time_left <= 0)
				mode = SHUTTLE_IDLE
				timer = 0
		if(SHUTTLE_CALL)
			if(time_left <= 0)
				//move emergency shuttle to station
				if(initiate_docking(SSshuttle.getDock("emergency_home")) != DOCKING_SUCCESS)
					setTimer(20)
					return
				mode = SHUTTLE_DOCKED
				setTimer(SSshuttle.emergencyDockTime)
				send2irc("Server", "The Emergency Shuttle has docked with the station.")
				priority_announce("The Emergency Shuttle has docked with the station. You have [timeLeft(600)] minutes to board the Emergency Shuttle.", null, 'hippiestation/sound/pyko/shuttledock.ogg', "Priority")
				ShuttleDBStuff()

		if(SHUTTLE_DOCKED)
			if(time_left <= ENGINES_START_TIME)
				mode = SHUTTLE_IGNITING
				SSshuttle.checkHostileEnvironment()
				if(mode == SHUTTLE_STRANDED)
					return
				for(var/A in SSshuttle.mobile)
					var/obj/docking_port/mobile/M = A
					if(M.launch_status == UNLAUNCHED) //Pods will not launch from the mine/planet, and other ships won't launch unless we tell them to.
						M.check_transit_zone()

		if(SHUTTLE_IGNITING)
			var/success = TRUE
			SSshuttle.checkHostileEnvironment()
			if(mode == SHUTTLE_STRANDED)
				return

			success &= (check_transit_zone() == TRANSIT_READY)
			for(var/A in SSshuttle.mobile)
				var/obj/docking_port/mobile/M = A
				if(M.launch_status == UNLAUNCHED)
					success &= (M.check_transit_zone() == TRANSIT_READY)
			if(!success)
				setTimer(ENGINES_START_TIME)

			if(time_left <= 50 && !sound_played) //4 seconds left:REV UP THOSE ENGINES BOYS. - should sync up with the launch
				sound_played = 1 //Only rev them up once.
				var/list/areas = list()
				for(var/area/shuttle/escape/E in GLOB.sortedAreas)
					areas += E
				hyperspace_sound(HYPERSPACE_WARMUP, areas)

			if(time_left <= 0 && !SSshuttle.emergencyNoEscape)
				//move each escape pod (or applicable spaceship) to its corresponding transit dock
				for(var/A in SSshuttle.mobile)
					var/obj/docking_port/mobile/M = A
					M.on_emergency_launch()

				//now move the actual emergency shuttle to its transit dock
				var/list/areas = list()
				for(var/area/shuttle/escape/E in GLOB.sortedAreas)
					areas += E
				hyperspace_sound(HYPERSPACE_LAUNCH, areas)
				enterTransit()
				mode = SHUTTLE_ESCAPE
				launch_status = ENDGAME_LAUNCHED
				setTimer(SSshuttle.emergencyEscapeTime * engine_coeff)
				priority_announce("The Emergency Shuttle has left the station. Estimate [timeLeft(600)] minutes until the shuttle docks at Central Command.", null, 'hippiestation/sound/pyko/shuttleleave.ogg', "Priority")

		if(SHUTTLE_STRANDED)
			SSshuttle.checkHostileEnvironment()

		if(SHUTTLE_DISABLED) //SHUTTLE DISABLED CHECK
			SSshuttle.checkHostileEnvironment()

		if(SHUTTLE_ESCAPE)
			if(sound_played && time_left <= HYPERSPACE_END_TIME)
				var/list/areas = list()
				for(var/area/shuttle/escape/E in GLOB.sortedAreas)
					areas += E
				hyperspace_sound(HYPERSPACE_END, areas)
			if(time_left <= PARALLAX_LOOP_TIME)
				var/area_parallax = FALSE
				for(var/place in shuttle_areas)
					var/area/shuttle/shuttle_area = place
					if(shuttle_area.parallax_movedir)
						area_parallax = TRUE
						break
				if(area_parallax)
					parallax_slowdown()
					for(var/A in SSshuttle.mobile)
						var/obj/docking_port/mobile/M = A
						if(M.launch_status == ENDGAME_LAUNCHED)
							if(istype(M, /obj/docking_port/mobile/pod))
								M.parallax_slowdown()

			if(time_left <= 0)
				//move each escape pod to its corresponding escape dock
				for(var/A in SSshuttle.mobile)
					var/obj/docking_port/mobile/M = A
					M.on_emergency_dock()

				// now move the actual emergency shuttle to centcom
				// unless the shuttle is "hijacked"
				var/destination_dock = "emergency_away"
				if(is_hijacked())
					destination_dock = "emergency_syndicate"
					minor_announce("Corruption detected in \
						shuttle navigation protocols. Please contact your \
						supervisor.", "SYSTEM ERROR:", alert=TRUE)

				dock_id(destination_dock)
				mode = SHUTTLE_ENDGAME
				timer = 0

/obj/machinery/computer/shuttle/pod/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED) //MODULE: SHUTTLE TOGGLE
		return
	ENABLE_BITFIELD(obj_flags, EMAGGED)
	to_chat(user, "<span class='warning'>You fry the pod's alert level checking system.</span>")
