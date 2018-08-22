/mob/dead/observer
	var/antag_hud = FALSE

/mob/dead/observer/verb/antag_hud()
	set category = "Ghost"
	set name = "Toggle Antag HUD"

	if(!antag_hud)
		if(alert("Are you sure you want to enable Antag HUD? This will prevent you from being revived!", "Are you sure?", "No", "Yes") != "Yes")
			return
	antag_hud = TRUE
	can_reenter_corpse = FALSE
	if(istype(mind, /datum/mind) && isliving(mind.current))
		var/mob/living/M = mind.current
		M.hellbound = TRUE
	var/adding_hud = !client.has_antag_hud()
	for(var/datum/atom_hud/antag/H in GLOB.huds) // add antag huds
		(adding_hud) ? H.add_hud_to(usr) : H.remove_hud_from(usr)