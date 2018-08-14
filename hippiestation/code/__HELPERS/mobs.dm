/proc/slot_to_string(slot)
	switch(slot)
		if(SLOT_BACK)
			return "Backpack"
		if(SLOT_WEAR_MASK)
			return "Mask"
		if(SLOT_HANDS)
			return "Hands"
		if(SLOT_BELT)
			return "Belt"
		if(SLOT_EARS)
			return "Ears"
		if(SLOT_GLASSES)
			return "Glasses"
		if(SLOT_GLOVES)
			return "Gloves"
		if(SLOT_NECK)
			return "Neck"
		if(SLOT_HEAD)
			return "Head"
		if(SLOT_SHOES)
			return "Shoes"
		if(SLOT_WEAR_SUIT)
			return "Suit"
		if(SLOT_W_UNIFORM)
			return "Jumpsuit"
		if(SLOT_IN_BACKPACK)
			return "In backpack"

/proc/deadchat_broadcast(message, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
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