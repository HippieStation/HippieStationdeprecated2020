/datum/dynamic_ruleset/roundstart/choose
	name = "Choice"
	antag_flag = ROLE_TRAITOR
	minimum_required_age = 0
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Vice Officer")
	restricted_roles = list("Cyborg")
	required_candidates = 1
	weight = 5
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
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Vice Officer")
	restricted_roles = list("Cyborg")
	required_candidates = 2
	minimum_players = 20
	weight = 20
	cost = 25
	antag_datum = /datum/antagonist/hivemind

/datum/dynamic_ruleset/roundstart/hivemind/pre_execute()
	var/num_hosts = max( 1 , rand(0,1) + min(8, round(mode.roundstart_pop_ready / 8) ) ) //1 host for every 8 players up to 64, with a 50% chance of an extra
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
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Vice Officer")
	restricted_roles = list("Cyborg")
	required_candidates = 2
	weight = 15
	cost = 20
	minimum_players = 20
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

/datum/dynamic_ruleset/roundstart/revs
	restricted_roles = list("AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Vice Officer")
	weight = 30
	minimum_players = 25

/datum/dynamic_ruleset/roundstart/traitor
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Vice Officer")
	weight = 35
	
/datum/dynamic_ruleset/roundstart/monkey
	weight = 2
	cost = 50
	requirements = list(101,101,70,40,30,20,10,10,10,10)
	high_population_requirement = 10
	flags = HIGHLANDER_RULESET
	
/datum/dynamic_ruleset/roundstart/nuclear
	weight = 20
	required_candidates = 1

/datum/dynamic_ruleset/roundstart/nuclear/clown_ops
	requirements = list(90,90,90,80,60,40,30,20,10,10)
	high_population_requirement = 10
	weight = 3
	
/datum/dynamic_ruleset/roundstart/clockcult
	cost = 50
	weight = 3
	requirements = list(100,90,80,60,40,30,10,10,10,10)
	high_population_requirement = 10
	
/datum/dynamic_ruleset/roundstart/wizard
	weight = 20
	
/datum/dynamic_ruleset/roundstart/bloodcult
	restricted_roles = list("AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Chaplain", "Head of Personnel", "Vice Officer")
	weight = 30

/datum/dynamic_ruleset/roundstart/infiltrator
	name = "Infiltration Unit"
	antag_flag = ROLE_INFILTRATOR
	antag_datum = /datum/antagonist/infiltrator
	minimum_required_age = 14
	required_candidates = 3
	weight = 10
	cost = 25
	requirements = list(90,90,90,80,60,40,30,20,10,10)
	high_population_requirement = 10
	var/infil_cap = list(2,3,3,3,3,4,4,5,5,5)
	var/datum/team/infiltrator/sit_team

/datum/dynamic_ruleset/roundstart/infiltrator/ready(forced = FALSE)
	required_candidates = infil_cap[indice_pop]
	. = ..()

/datum/dynamic_ruleset/roundstart/infiltrator/pre_execute()
	// If ready() did its job, candidates should have 5 or more members in it
	var/infiltrators = infil_cap[indice_pop]
	for(var/infils_number = 1 to infiltrators)
		if(candidates.len <= 0)
			break
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.assigned_role = ROLE_INFILTRATOR
		M.mind.special_role = ROLE_INFILTRATOR
	return TRUE

/datum/dynamic_ruleset/roundstart/infiltrator/execute()
	sit_team = new /datum/team/infiltrator
	for(var/datum/mind/M in assigned)
		M.add_antag_datum(/datum/antagonist/infiltrator, sit_team)
	sit_team.update_objectives()
	return TRUE
