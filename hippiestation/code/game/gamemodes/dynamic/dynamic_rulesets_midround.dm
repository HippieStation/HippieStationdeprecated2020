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
