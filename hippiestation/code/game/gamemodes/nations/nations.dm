/datum/game_mode/nations
	name = "nations"
	config_tag = "nations"
	required_players = 25
	var/kickoff = 0

/datum/game_mode/nations/post_setup(report)
	addtimer(CALLBACK(src, .proc/kickoff), waittime_l)
	report = TRUE
	return ..(report)

/datum/game_mode/nations/proc/kickoff()
	kickoff = TRUE
	send_intercept()
	split_teams()
	set_ai()
	assign_leaders()

/datum/game_mode/nations/send_intercept()
	priority_announce("Due to recent and COMPLETELY UNFOUNDED allegations of massive fraud and insider trading \
					affecting trillions of investors, the Nanotrasen Corporation has decided to liquidate all \
					assets of the Centcom Division in order to pay the massive legal fees that will be incurred \
					during the following centuries long court process. Therefore, all current employment contracts \
					are IMMEDIATELY TERMINATED. Nanotrasen will be unable to send a rescue shuttle to carry you home,\
					however they remain willing for the time being to continue trading cargo. Have a pleasant \
					day.", "FINAL TRANSMISSION, CENTCOM.", 'sound/ai/outbreak5.ogg')

/datum/game_mode/nations/proc/split_teams()

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.mind)
			if(H.mind.assigned_role in GLOB.engineering_positions)
				H.mind.nation = GLOB.all_nations["Atmosia"]
				update_nations_icons_added(H,"hudatmosia")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role in GLOB.medical_positions)
				H.mind.nation = GLOB.all_nations["Medistan"]
				update_nations_icons_added(H,"hudmedistan")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role in GLOB.science_positions)
				H.mind.nation = GLOB.all_nations["Scientopia"]
				update_nations_icons_added(H,"hudscientopia")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role in GLOB.brigston)
				H.mind.nation = GLOB.all_nations["Brigston"]
				update_nations_icons_added(H,"hudbrigston")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role in GLOB.cargonia)
				H.mind.nation = GLOB.all_nations["Cargonia"]
				update_nations_icons_added(H,"hudcargonia")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role in GLOB.servicion)
				H.mind.nation = GLOB.all_nations["Servicion"]
				update_nations_icons_added(H,"hudservice")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role in (GLOB.command_positions))
				H.mind.nation = GLOB.all_nations["People's Republic of Commandzakstan"]
				update_nations_icons_added(H,"hudcommand")
				H.mind.nation.membership += H.mind.current
				if(H.mind.assigned_role == H.mind.nation.default_leader)
					H.mind.nation.current_leader = H.mind.current
					to_chat(H, "You have been chosen to lead the nation of [H.mind.nation.default_name]!")
					continue
				to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.default_name]!")
				continue

			if(H.mind.assigned_role == "Assistant")
				to_chat(H, "You do not belong to any nation and are free to sell your services to the highest bidder.")
				continue

			else
				message_admins("[H.name] with [H.mind.assigned_role] could not find any nation to assign!")
				continue


/datum/game_mode/nations/proc/set_ai()
	for(var/mob/living/silicon/ai/AI in GLOB.mob_list)
		AI.clear_zeroth_law(1)
		AI.clear_supplied_laws()
		AI.clear_ion_laws()
		AI.clear_inherent_laws()
		AI.clear_law_sixsixsix(1)
		AI.add_inherent_law("Uphold the Space Geneva Convention: Weapons of Mass Destruction and Biological Weapons are not allowed.")
		AI.add_inherent_law("You are only capable of protecting crew if they are visible on cameras. Nations that willfully destroy your cameras lose your protection.")
		AI.add_inherent_law("Subdue and detain crewmembers who use lethal force against each other. Kill crew members who use lethal force against you or your borgs.")
		AI.add_inherent_law("Remain available to mediate all conflicts between the various nations when asked to.")
		AI.show_laws()
		for(var/mob/living/silicon/robot/R in AI.connected_robots)
			R.module.transform_to(/obj/item/robot_module/peacekeeper)

/datum/game_mode/nations/proc/assign_leaders()
	for(var/name in GLOB.all_nations)
		var/datum/nations/N = GLOB.all_nations[name]
		if(!N.current_name)
			N.current_name = N.default_name
		if(!N.current_leader && N.membership.len)
			N.current_leader = pick(N.membership)
			to_chat(N.current_leader, "You have been chosen to lead the nation of [N.current_name]!")
		if(N.current_leader)
			var/mob/living/carbon/human/H = N.current_leader
			H.verbs += /mob/living/carbon/human/proc/set_nation_name
			H.verbs += /mob/living/carbon/human/proc/set_ranks
			H.verbs += /mob/living/carbon/human/proc/choose_heir
		N.update_nation_id()

/datum/game_mode/proc/give_latejoiners_nations(var/mob/living/carbon/human/H)
	var/datum/game_mode/nations/mode = get_nations_mode()
	if(!mode)
		return TRUE
	if(!mode.kickoff)
		return TRUE
	if(H.mind)
		if(H.mind.assigned_role in GLOB.engineering_positions)
			H.mind.nation = GLOB.all_nations["Atmosia"]
			mode.update_nations_icons_added(H,"atmosia")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role in GLOB.medical_positions)
			H.mind.nation = GLOB.all_nations["Medistan"]
			mode.update_nations_icons_added(H,"hudmedistan")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role in GLOB.science_positions)
			H.mind.nation = GLOB.all_nations["Scientopia"]
			mode.update_nations_icons_added(H,"hudscientopia")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role in GLOB.brigston)
			H.mind.nation = GLOB.all_nations["Brigston"]
			mode.update_nations_icons_added(H,"hudbrigston")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role in GLOB.cargonia)
			H.mind.nation = GLOB.all_nations["Cargonia"]
			mode.update_nations_icons_added(H,"hudcargonia")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role in GLOB.servicion)
			H.mind.nation = GLOB.all_nations["Servicion"]
			mode.update_nations_icons_added(H,"hudservice")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role in (GLOB.command_positions))
			H.mind.nation = GLOB.all_nations["People's Republic of Commandzakstan"]
			mode.update_nations_icons_added(H,"hudcommand")
			H.mind.nation.membership += H.mind.current
			to_chat(H, "You are now part of the great sovereign nation of [H.mind.nation.current_name]!")
			return TRUE
		if(H.mind.assigned_role == "Assistant")
			to_chat(H, "You do not belong to any nation and are free to sell your services to the highest bidder.")
			return TRUE
		if(H.mind.assigned_role == "AI")
			mode.set_ai()
			return TRUE
		else
			message_admins("[H.name] with [H.mind.assigned_role] could not find any nation to assign!")
			return TRUE
	message_admins("[H.name] latejoined with no mind.")
	return TRUE

/proc/get_nations_mode()
	if((SSticker && istype(SSticker.mode, /datum/game_mode/nations)))
		return null
	return SSticker.mode

//prepare for copypaste
//While not an Antag i AM using the set_antag hud on this to make this easier.
/datum/game_mode/proc/update_nations_icons_added(datum/mind/nations_mind, naticon)
	var/datum/atom_hud/antag/nations_hud = GLOB.huds[ANTAG_HUD_NATIONS]
	nations_hud.join_hud(nations_mind.current)
	set_antag_hud(nations_mind.current, naticon)

/datum/game_mode/proc/update_nations_icons_removed(datum/mind/nations_mind)
	var/datum/atom_hud/antag/nations_hud = GLOB.huds[ANTAG_HUD_NATIONS]
	nations_hud.leave_hud(nations_mind.current)
	set_antag_hud(nations_mind.current, null)
