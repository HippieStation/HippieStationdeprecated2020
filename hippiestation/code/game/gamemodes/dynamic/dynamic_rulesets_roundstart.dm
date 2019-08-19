/datum/dynamic_ruleset/roundstart/choose
	name = "Choice"
	antag_flag = ROLE_TRAITOR
	minimum_required_age = 0
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("Cyborg")
	required_candidates = 1
	weight = 0.75
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


/datum/dynamic_ruleset/roundstart/hivemind
	name = "Hivemind"
	antag_flag = ROLE_HIVE
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("Cyborg")
	required_candidates = 2
	weight = 2
	cost = 25
	antag_datum = /datum/antagonist/hivemind

/datum/dynamic_ruleset/roundstart/hivemind/pre_execute()
	var/num_hosts = max( 1 , rand(0,1) + min(8, round(num_players() / 8) ) ) //1 host for every 8 players up to 64, with a 50% chance of an extra
	for (var/i = 1 to num_hosts)
		var/mob/M = pick(candidates)
		candidates -= M
		assigned += M.mind
		M.mind.restricted_roles = restricted_roles
		M.mind.special_role = ROLE_HIVE
	return TRUE


/datum/dynamic_ruleset/roundstart/abductors
	name = "Abductors"
	antag_flag = ROLE_ABDUCTOR
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("Cyborg")
	required_candidates = 2
	weight = 3
	cost = 25
	var/datum/mind/scientist
	var/datum/mind/agent

/datum/dynamic_ruleset/roundstart/abductors/pre_execute()
	if(!islist(candidates) || candidates.len < 2)
		return FALSE
	var/mob/S = pick(candidates)
	candidates -= S
	var/mob/A = pick(candidates)
	candidates -= A
	if(!S || !A || !S.mind || !A.mind)
		return FALSE
	assigned += S
	S.mind.special_role = ROLE_ABDUCTOR
	S.mind.assigned_role = ROLE_ABDUCTOR
	scientist = S.mind
	assigned += A
	A.mind.special_role = ROLE_ABDUCTOR
	A.mind.assigned_role = ROLE_ABDUCTOR
	agent = A.mind
	return TRUE

/datum/dynamic_ruleset/roundstart/abductors/execute()
	if(!scientist || !agent)
		return FALSE
	var/datum/team/abductor_team/T = new
	if(T.team_number > ABDUCTOR_MAX_TEAMS)
		return FALSE
	scientist.add_antag_datum(/datum/antagonist/abductor/scientist, T)
	agent.add_antag_datum(/datum/antagonist/abductor/agent, T)
	
/datum/dynamic_ruleset/roundstart/delayed/revs
	weight = 3
	minimum_players = 25

/datum/dynamic_ruleset/roundstart/traitor
	weight = 4
	
/datum/dynamic_ruleset/roundstart/monkey
	weight = 0.2
	requirements = list(101,101,70,40,30,20,10,10,10,10)
	high_population_requirement = 10
	flags = HIGHLANDER_RULESET
	
/datum/dynamic_ruleset/roundstart/nuclear
	required_candidates = 2

/datum/dynamic_ruleset/roundstart/nuclear/clown_ops
	requirements = list(90,90,90,80,60,40,30,20,10,10)
	high_population_requirement = 10
	weight = 0.3
