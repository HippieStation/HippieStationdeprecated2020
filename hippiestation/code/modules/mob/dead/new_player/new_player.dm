/mob/dead/new_player/IsJobUnavailable(rank, latejoin = FALSE)
	. = ..()
	if(. == JOB_AVAILABLE)
		if(jobban_isbanned(src, CLUWNEBAN) || jobban_isbanned(src, CATBAN) && rank != SSjob.overflow_role)
			return JOB_UNAVAILABLE_BANNED