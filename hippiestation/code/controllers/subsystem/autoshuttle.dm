SUBSYSTEM_DEF(autoshuttle)
	name = "Autoshuttle"
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME
	var/alive = 0
	var/call_threshold = 0



/datum/controller/subsystem/autoshuttle/fire()
	if(SSshuttle.emergencyNoRecall)
		return
	alive = 0
	call_threshold = (GLOB.joined_player_list.len * 0.2)//if %20 of the players is dead,afk or otherwise not in the round we will call the shuttle.
	for(var/mob/living/L in GLOB.player_list)
		if(L.stat != DEAD)
			alive++
	if((alive < call_threshold) && ((SSshuttle.emergency.timeLeft(1) > (SSshuttle.emergencyCallTime * 0.4)))) //lets make sure that if the shuttle is already coming that the new shuttle call isn't slower.
		log_admin("The shuttle was automatically called due to dead players.")
		message_admins("Automatically dispatching shuttle due to crew death.")
		SSshuttle.emergencyNoRecall = TRUE
		SSshuttle.emergency.request(null, set_coefficient = 0.4)
		priority_announce("Catastrophic casualties detected: crisis shuttle protocols activated - jamming recall signals across all frequencies.")