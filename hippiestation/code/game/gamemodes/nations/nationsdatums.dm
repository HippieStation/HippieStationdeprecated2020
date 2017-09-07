/datum/nations
	var/current_name
	var/default_leader
	var/current_leader
	var/list/membership = list()
	var/leader_rank = "Leader"
	var/heir_rank = "Heir"
	var/member_rank = "Member"
	var/heir

/datum/mind
	var/datum/nations/nation

/datum/nations/atmosia
	name = "Atmosia"
	default_leader = "Chief Engineer"

/datum/nations/brigston
	name = "Brigston"
	default_leader = "Head of Security"

/datum/nations/cargonia
	name = "Cargonia"
	default_leader = "Quartermaster"

/datum/nations/command
	name = "People's Republic of Commandzakstan"
	default_leader = "Captain"

/datum/nations/medistan
	name = "Medistan"
	default_leader = "Chief Medical Officer"

/datum/nations/scientopia
	name = "Scientopia"
	default_leader = "Research Director"

/datum/nations/service
	name = "Servicion"
	default_leader = "Bartender"