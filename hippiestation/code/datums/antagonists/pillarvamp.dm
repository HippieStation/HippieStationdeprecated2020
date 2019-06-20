/datum/antagonist/vampire/pillarmen
	name = "Pillar Man Vampire"
	antagpanel_category = "Pillar Men"
	var/datum/team/pillarmen/pillarTeam
	var/list/datum/antagonist/pillar_thrall/thralls

/datum/antagonist/vampire/pillarmen/create_team(datum/team/pillarmen/team)
	if(istype(team))
		pillarTeam = team
		owner.current.faction |= "pillarmen_[pillarTeam.pillar_id]"
