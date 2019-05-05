//Shadowling
/datum/admins/proc/makeShadowling()
	var/datum/game_mode/shadowling/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs
	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"
	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H
	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(ROLE_SHADOWLING in applicant.client.prefs.be_special)
			if(!applicant.stat)
				if(applicant.mind)
					if(!applicant.mind.special_role)
						if(!is_banned_from(applicant.ckey, ROLE_SHADOWLING) && !is_banned_from(applicant.ckey, ROLE_SYNDICATE) && !is_banned_from(applicant.ckey, CLUWNEBAN) && !is_banned_from(applicant.ckey, CATBAN))
							if(temp.age_check(applicant.client))
								if(!(applicant.job in temp.restricted_jobs))
									if(!(is_shadow_or_thrall(applicant)))
										candidates += applicant

	if(candidates.len)
		H = pick(candidates)
		H.add_sling()
		return TRUE
	return FALSE

/datum/admins/proc/makeVampire()
	var/datum/game_mode/vampire/temp = new
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		temp.restricted_jobs += temp.protected_jobs
	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		temp.restricted_jobs += "Assistant"
	var/list/mob/living/carbon/human/candidates = list()
	var/mob/living/carbon/human/H
	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if((ROLE_VAMPIRE in applicant.client.prefs.be_special) && !applicant.stat && applicant.mind && !applicant.mind.special_role)
			if(!is_banned_from(applicant.ckey, ROLE_VAMPIRE) && !is_banned_from(applicant.ckey, ROLE_SYNDICATE) && !is_banned_from(applicant.ckey, CLUWNEBAN) && !is_banned_from(applicant.ckey, CATBAN))
				if(temp.age_check(applicant.client) && !(applicant.job in temp.restricted_jobs) && !is_vampire(applicant))
					candidates += applicant

	if(LAZYLEN(candidates))
		H = pick(candidates)
		add_vampire(H)
		return TRUE
	return FALSE

/datum/admins/proc/makeInfiltratorTeam()
	var/datum/game_mode/infiltration/temp = new
	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you wish to be considered for a infiltration team being sent in?", ROLE_INFILTRATOR, temp)
	var/list/mob/dead/observer/chosen = list()
	var/mob/dead/observer/theghost = null

	if(candidates.len)
		var/numagents = 5
		var/agentcount = 0

		for(var/i = 0, i<numagents,i++)
			shuffle_inplace(candidates) //More shuffles means more randoms
			for(var/mob/j in candidates)
				if(!j || !j.client)
					candidates.Remove(j)
					continue

				theghost = j
				candidates.Remove(theghost)
				chosen += theghost
				agentcount++
				break
		//Making sure we have atleast 3 Nuke agents, because less than that is kinda bad
		if(agentcount < 3)
			return FALSE

		//Let's find the spawn locations
		var/datum/team/infiltrator/TI = new/datum/team/infiltrator/
		for(var/mob/c in chosen)
			var/mob/living/carbon/human/new_character=makeBody(c)
			new_character.mind.add_antag_datum(/datum/antagonist/infiltrator, TI)
		TI.update_objectives()
		return TRUE
	else
		return FALSE
