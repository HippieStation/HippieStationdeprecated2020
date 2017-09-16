
/datum/job/ai/proc/can_be_malf(mob/living/M)
	if(jobban_isbanned(M, "Syndicate") || jobban_isbanned(M, ROLE_MALF) || jobban_isbanned(M, ROLE_TRAITOR))
		return FALSE
	if(ROLE_MALF in M.client.prefs.be_special)
		return TRUE
	return FALSE

/datum/job/ai/after_spawn(mob/living/silicon/ai/AI, mob/M)
	. = ..()
	if(can_be_malf(M))
		var/malf_prob = config.malf_chance[SSticker.mode.config_tag]
		if((malf_prob && prob(malf_prob)) && AI.mind)
			if(SSticker.current_state < GAME_STATE_PLAYING)
				SSticker.OnRoundstart(CALLBACK(src, .proc/make_malf, AI))
			else
				addtimer(CALLBACK(src, .proc/make_malf, AI), rand(15, 50))

/datum/job/ai/proc/make_malf(mob/living/silicon/ai/AI)
	AI.mind.make_Traitor()
	message_admins("The AI, [AI], rolled malf!")
	log_game("The AI, [AI], rolled malf!")