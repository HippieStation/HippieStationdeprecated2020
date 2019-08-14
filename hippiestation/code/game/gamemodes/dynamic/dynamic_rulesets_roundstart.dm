/datum/dynamic_ruleset/roundstart/choose
	name = "Choice"
	antag_flag = ROLE_TRAITOR
	minimum_required_age = 0
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("Cyborg")
	required_candidates = 1
	weight = 0.1
	cost = 10
	requirements = list(10,10,10,10,10,10,10,10,10,10)
	high_population_requirement = 10

/datum/dynamic_ruleset/roundstart/choose/pre_execute()
	var/num = FLOOR(max((GLOB.player_list.len - 10) / 8, 1), 1)
	for (var/i = 1 to num)
		var/mob/M = pick(candidates)
		candidates -= M
		assigned += M.mind
		M.mind.restricted_roles = restricted_roles
	return TRUE

/datum/dynamic_ruleset/roundstart/choose/execute()
	for(var/datum/mind/lucky in assigned)
		INVOKE_ASYNC(src, .proc/let_choice, lucky)
	return TRUE

/datum/dynamic_ruleset/roundstart/choose/proc/let_choice(datum/mind/M)
	var/choice
	while(!choice)
		choice = input(M.current, "Which antagonist would you like to be?", "Your lucky day!") as null|anything in list("Traitor", "Vampire", "Devil", "Hivemind")
		if(!choice)
			continue
		switch(choice)
			if("Traitor")
				M.add_antag_datum(/datum/antagonist/traitor)
				M.special_role = ROLE_TRAITOR
			if("Vampire")
				M.add_antag_datum(/datum/antagonist/vampire)
				M.special_role = ROLE_VAMPIRE
			if("Devil")
				M.add_antag_datum(/datum/antagonist/devil)
				M.special_role = ROLE_DEVIL
			if("Hivemind")
				M.add_antag_datum(/datum/antagonist/hivemind)
				M.special_role = ROLE_HIVE
