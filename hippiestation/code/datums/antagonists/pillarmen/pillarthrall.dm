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

/datum/antagonist/pillar_thrall/apply_innate_effects()
	..()
	owner.store_memory("Your Vampire master is <b>[master.owner.name]</b>.")
	owner.store_memory("Your Pillar Man master is <b>[pillarTeam.pillarMan.name]</b>.")
	update_pillar_icons_added()

/datum/antagonist/pillar_thrall/remove_innate_effects()
	update_pillar_icons_removed()
	..()

/datum/antagonist/pillar_thrall/create_team(datum/team/pillarmen/team)
	if(istype(team))
		pillarTeam = team
		pillarTeam.thralls |= owner

// Dynamically creates the HUD for the team if it doesn't exist already, inserting it into the global huds list, and assigns it to the user. The index is saved into a var owned by the team datum.
/datum/antagonist/pillar_thrall/proc/update_pillar_icons_added(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[pillarTeam.hud_entry_num]
	if(!pillarhud)
		pillarhud = new()
		pillarTeam.hud_entry_num = GLOB.huds.len + 1 // the index of the hud inside huds list
		GLOB.huds += pillarhud
	pillarhud.join_hud(owner.current)
	set_antag_hud(owner.current, "pthrall")

// Removes hud. Destroying the hud datum itself in case the team is deleted is done on team Destroy().
/datum/antagonist/pillar_thrall/proc/update_pillar_icons_removed(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/pillarhud = GLOB.huds[pillarTeam.hud_entry_num]
	if(pillarhud)
		pillarhud.leave_hud(owner.current)
		set_antag_hud(owner.current, null)

