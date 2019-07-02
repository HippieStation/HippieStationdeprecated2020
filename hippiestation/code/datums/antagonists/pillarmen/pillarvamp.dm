/datum/antagonist/vampire/pillarmen
	name = "Pillar Man Vampire"
	antagpanel_category = "Pillar Men"
	var/datum/team/pillarmen/pillarTeam
	var/list/datum/antagonist/pillar_thrall/thralls

/datum/antagonist/vampire/pillarmen/apply_innate_effects()
	..()
	owner.store_memory("Your Pillar Man master is <b>[pillarTeam.pillarMan.name]</b>.")
	update_pillar_icons_added()

/datum/antagonist/vampire/pillarmen/remove_innate_effects()
	update_pillar_icons_removed()
	..()

/datum/antagonist/vampire/pillarmen/on_removal()
	. = ..()
	pillarTeam.vampires -= owner

/datum/antagonist/vampire/pillarmen/create_team(datum/team/pillarmen/team)
	if(istype(team))
		pillarTeam = team
		pillarTeam.vampires += owner



/datum/antagonist/vampire/pillarmen/greet()
	. = ..()
	to_chat(owner, "<span class='bold big notice'>You are a special kind of vampire, transformed by the Stone Mask. You lack much of your cortex for free will - you are instead controlled and owned by your Pillar Man master!</span>")
	to_chat(owner, "<span class='bold big notice'>However, this makes room in your brain for special abilities!</span>")

/datum/antagonist/vampire/pillarmen/proc/update_pillar_icons_added(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[pillarTeam.hud_entry_num]
	if(!pillarhud)
		pillarhud = new()
		pillarTeam.hud_entry_num = GLOB.huds.len + 1 // the index of the hud inside huds list
		GLOB.huds += pillarhud
	pillarhud.join_hud(owner.current)
	set_antag_hud(owner.current, "vampire")

// Removes hud. Destroying the hud datum itself in case the team is deleted is done on team Destroy().
/datum/antagonist/vampire/pillarmen/proc/update_pillar_icons_removed(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[pillarTeam.hud_entry_num]
	if(pillarhud)
		pillarhud.leave_hud(owner.current)
		set_antag_hud(owner.current, null)
