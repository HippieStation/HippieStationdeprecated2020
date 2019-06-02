/datum/game_mode/proc/pick_with_tokens(list/datum/candidates, antag_type)
	if(GLOB.allow_antag_tokens)
		for(var/datum/mind/mind in candidates)
			if(GLOB.token_users[ckey(mind.key)] == TRUE)
				if(mind.current.client.ticket_holder.RedeemAntagTicket("Chosen for antagonist role", antag_type))
					GLOB.token_users[ckey(mind.key)] = FALSE
					return mind
	return pick(candidates)
