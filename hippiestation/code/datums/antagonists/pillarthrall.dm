/datum/antagonist/pillar_thrall
	name = "Pillar Man Thrall"
	antagpanel_category = "Pillar Men"
	var/datum/antagonist/vampire/pillarmen/master
	var/datum/team/pillarmen/pillarTeam

/datum/antagonist/pillar_thrall/create_team(datum/team/pillarmen/team)
	if(istype(team))
		pillarTeam = team
