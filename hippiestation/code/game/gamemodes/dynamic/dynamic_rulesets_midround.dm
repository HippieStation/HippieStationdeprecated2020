/datum/dynamic_ruleset/midround/from_ghosts/review_applications()
	if(required_candidates > candidates.len)
		message_admins("The ruleset [name] didn't recieve enough applications (got [candidates.len], needed [required_candidates]).")
		log_game("DYNAMIC: The ruleset [name] didn't recieve enough applications (got [candidates.len], needed [required_candidates]).")
		mode.refund_threat(cost)
		mode.threat_log += "[worldtime2text()]: Rule [name] refunded [cost] (not enough applications)"
		mode.executed_rules -= src
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/abductor
	name = "Abductors"
	antag_flag = ROLE_ABDUCTOR
	required_candidates = 2
	weight = 3
	cost = 15
	high_population_requirement = 10
	var/datum/team/abductor_team/team

/datum/dynamic_ruleset/midround/from_ghosts/abductor/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	team = new
	if(team.team_number > ABDUCTOR_MAX_TEAMS)
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/abductor/finish_setup(mob/new_character, index)
	new_character.mind.special_role = ROLE_ABDUCTOR
	new_character.mind.assigned_role = ROLE_ABDUCTOR
	if (index == 1)
		new_character.mind.add_antag_datum(/datum/antagonist/abductor/scientist, team)
	else
		new_character.mind.add_antag_datum(/datum/antagonist/abductor/agent, team)

/datum/dynamic_ruleset/midround/autotraitor
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Vice Officer")

/datum/dynamic_ruleset/midround/malf
	enemy_roles = list("Security Officer", "Warden","Detective","Head of Security", "Captain", "Scientist", "Chemist", "Research Director", "Chief Engineer", "Vice Officer")
