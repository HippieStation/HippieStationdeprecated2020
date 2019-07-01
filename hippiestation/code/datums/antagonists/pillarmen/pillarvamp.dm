/datum/antagonist/vampire/pillarmen
	name = "Pillar Man Vampire"
	antagpanel_category = "Pillar Men"
	var/datum/team/pillarmen/pillarTeam
	var/list/datum/antagonist/pillar_thrall/thralls

/datum/antagonist/vampire/pillarmen/on_gain()
	. = ..()

/datum/antagonist/vampire/pillarmen/on_removal()
	. = ..()
	pillarTeam.vampires -= owner

/datum/antagonist/vampire/pillarmen/create_team(datum/team/pillarmen/team)
	if(istype(team))
		pillarTeam = team
		pillarTeam.vampires |= owner

/datum/antagonist/vampire/pillarmen/greet()
	. = ..()
	to_chat(owner, "<span class='bold big notice'>You are a special kind of vampire, transformed by the Stone Mask. You lack much of your cortex for free will - you are instead controlled and owned by your Pillar Man master!</span>")
	to_chat(owner, "<span class='bold big notice'>However, this makes room in your brain for special abilities!</span>")
