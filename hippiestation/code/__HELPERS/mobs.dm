/proc/slot_to_string(slot)
	switch(slot)
		if(slot_back)
			return "Backpack"
		if(slot_wear_mask)
			return "Mask"
		if(slot_hands)
			return "Hands"
		if(slot_belt)
			return "Belt"
		if(slot_ears)
			return "Ears"
		if(slot_glasses)
			return "Glasses"
		if(slot_gloves)
			return "Gloves"
		if(slot_neck)
			return "Neck"
		if(slot_head)
			return "Head"
		if(slot_shoes)
			return "Shoes"
		if(slot_wear_suit)
			return "Suit"
		if(slot_w_uniform)
			return "Jumpsuit"
		if(slot_in_backpack)
			return "In backpack"

proc/deadchat_broadcast(message, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
	for(var/mob/M in GLOB.player_list)	//Stop the message if our dudes are alive and do not have the medium trait, living mobs can now use deadchat!!
		var/mob/living/carbon/human/H = M
		var/datum/preferences/prefs
		if(M.client && M.client.prefs)
			prefs = M.client.prefs
		else
			prefs = new

		var/adminoverride = 0
		if(M.client && M.client.holder && (prefs.chat_toggles & CHAT_DEAD))
			adminoverride = 1
		if(isnewplayer(M) && !adminoverride)
			continue
		if(M.stat != DEAD && !H.has_trait(TRAIT_MEDIUM) && !adminoverride)
			continue
		if(speaker_key && speaker_key in prefs.ignoring)
			continue

		switch(message_type)
			if(DEADCHAT_DEATHRATTLE)
				if(prefs.toggles & DISABLE_DEATHRATTLE)
					continue
			if(DEADCHAT_ARRIVALRATTLE)
				if(prefs.toggles & DISABLE_ARRIVALRATTLE)
					continue

		if(isobserver(M))
			var/rendered_message = message

			if(follow_target)
				var/F
				if(turf_target)
					F = FOLLOW_OR_TURF_LINK(M, follow_target, turf_target)
				else
					F = FOLLOW_LINK(M, follow_target)
				rendered_message = "[F] [message]"
			else if(turf_target)
				var/turf_link = TURF_LINK(M, turf_target)
				rendered_message = "[turf_link] [message]"

			to_chat(M, rendered_message)
		else
			to_chat(M, message)