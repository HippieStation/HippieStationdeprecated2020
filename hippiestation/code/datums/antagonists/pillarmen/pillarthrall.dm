/datum/antagonist/pillar_thrall
	name = "Pillar Man Thrall"
	antagpanel_category = "Pillar Men"
	var/datum/antagonist/vampire/pillarmen/master
	var/datum/team/pillarmen/pillarTeam

/datum/antagonist/pillar_thrall/greet()
	to_chat(owner, "<span class='reallybig cult'>You are a thrall of the Vampire [master.owner.name], and of the Pillar Man [pillarTeam.pillarMan.name].</span>")
	to_chat(owner, "<span class='cult'>Follow their orders at all costs, even at the cost of your own life.</span>")

/datum/antagonist/pillar_thrall/on_removal()
	. = ..()
	pillarTeam.thralls -= owner

/datum/antagonist/pillar_thrall/create_team(datum/team/pillarmen/team)
	if(istype(team))
		pillarTeam = team
		pillarTeam.thralls |= owner

