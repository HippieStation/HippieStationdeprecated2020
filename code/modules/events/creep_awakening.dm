/datum/round_event_control/creep
	name = "Creep Awakening"
	typepath = /datum/round_event/creep
	max_occurrences = 1
	min_players = 20

/datum/round_event/creep
	fakeable = FALSE

/datum/round_event/creep/start()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.player_list))
		if(!H.client)
			continue
		if(H.stat == DEAD)
			continue
		if(!SSjob.GetJob(H.mind.assigned_role) || H.mind.assigned_role in GLOB.nonhuman_positions) //only station jobs sans nonhuman roles, prevents ashwalkers falling in love with crewmembers they never met
			continue
		if(H.mind.has_antag_datum(/datum/antagonist/creep))
			continue
		if(!H.getorgan(/obj/item/organ/brain))
			continue
		H.gain_trauma(/datum/brain_trauma/special/creep)
		announce_to_ghosts(H)
		break
