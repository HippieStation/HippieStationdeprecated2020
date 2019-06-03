/datum/game_mode/traitor/kotd
	name = "King of the Disk"
	config_tag = "kotd"
	antag_flag = ROLE_KOTD
	required_players = 25
	required_enemies = 8
	recommended_enemies = 10
	reroll_friendly = 0
	traitor_name = "Syndicate Recruit"
	restricted_jobs = list("Cyborg", "AI")

	traitors_possible = 12
	num_modifier = 6
	antag_datum = /datum/antagonist/traitor/kotd

	announce_span = "danger"
	announce_text = "The current game mode is - King of the Disk!\n\
					<span class='danger'>Syndicate Recruits:</span> Prove your worth to the Syndicate by stealing the nuke disk or escaping alive with the most telecrystals.\n\
					<span class='notice'>Crew:</span> Do not let the recruits succeed!"

/datum/antagonist/traitor/kotd
	name = "Syndicate Recruit"
	roundend_category = "recruits"
	special_role = "Syndicate Recruit"
	antagpanel_category = "Syndicate Recruit"
	var/king_time

/datum/antagonist/traitor/kotd/greet()
	..()
	to_chat(owner.current, "<span class='bold'>The Syndicate have sent a batch of recruits on a mission to prove your worth. You have been provided with an uplink with less telecrystals than a \
		proper agent, but by holding onto the Nuclear Authentication Disk, you will be granted one per minute. Escape alive and free with the most telecrystals or end the shift \
		with the nuke disk in your possession to be accepted into the ranks of the Syndicate!</span>")

/datum/antagonist/traitor/kotd/apply_innate_effects()
	var/datum/component/uplink/U = owner.find_syndicate_uplink()
	if(U)
		U.telecrystals = 10
	..()

/datum/antagonist/traitor/kotd/on_gain()
	START_PROCESSING(SSprocessing, src)
	.=..()
/datum/antagonist/traitor/kotd/on_removal()
	STOP_PROCESSING(SSprocessing,src)
	.=..()

/datum/antagonist/traitor/kotd/forge_traitor_objectives()
	// Steal the disk and/or escape
	var/datum/objective/steal/kotd/disk_objective = new
	disk_objective.owner = owner
	objectives += disk_objective
	disk_objective.give_special_equipment(disk_objective.targetinfo.special_equipment)

/datum/antagonist/traitor/kotd/process()
	if(!owner.current)
		return
	var/mob/living/M = owner.current
	var/list/all_items = M.GetAllContents()
	var/has_disk = FALSE
	for(var/obj/item/disk/nuclear/N in all_items)
		if(N.fake)
			continue
		has_disk = TRUE
		if(king_time > world.time)
			continue
		king_time = world.time + 600
		for(var/atom/I in all_items)
			var/datum/component/uplink/U = I.GetComponent(/datum/component/uplink)
			if(!U)
				continue
			U.telecrystals += 1
			to_chat(M,"<span class='notice'>Your uplink inside the [I] vibrates softly. The Syndicate have rewarded you with an additional telecrystal for your possession of the disk.</span>")
			if(U.active)
				U.interact(M)
	if(!has_disk || get_area(owner.current) == /area/space)
		king_time = world.time + 600

/datum/game_mode/traitor/kotd/generate_report()
	return "Due to recent agressive recruitment efforts of the Syndicate, an activity spike can be expected in your sector. We believe an older method of recruitment\
			is in play that favours quantity over quality and then weeding out the weak on field tests."
