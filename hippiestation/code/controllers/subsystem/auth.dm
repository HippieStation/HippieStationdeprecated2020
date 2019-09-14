PROCESSING_SUBSYSTEM_DEF(auth)
	name = "Authentication"
	wait = 20
	priority = 94 // just after DBCore
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING
	runlevels = RUNLEVEL_INIT | RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME // we want this to IMMEDIATLY run the instant it's initialized
	var/datum/auth_provider/provider

/datum/controller/subsystem/processing/auth/Initialize()
	. = ..()
	for(var/P in subtypesof(/datum/auth_provider))
		var/datum/auth_provider/AP = P
		if(initial(AP.id) == CONFIG_GET(string/auth_provider))
			provider = new P(null, TRUE)
			break
	for(var/mob/dead/unauthed/UA in world)
		UA.auth_setup()
