//gang.dm
//Gang War Game Mode
GLOBAL_LIST_INIT(possible_gangs, subtypesof(/datum/team/gang))
/datum/game_mode/gang
	name = "gang war"
	config_tag = "gang"
	antag_flag = ROLE_GANG
	restricted_jobs = list("Security Officer", "Warden", "Detective", "AI", "Cyborg","Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer")
	required_players = 15
	required_enemies = 2
	recommended_enemies = 2
	enemy_minimum_age = 14

	announce_span = "danger"
	announce_text = "A violent turf war has erupted on the station!\n\
	<span class='danger'>Gangsters</span>: Take over the station with a dominator.\n\
	<span class='notice'>Crew</span>: Prevent the gangs from expanding and initiating takeover."

	var/list/gangs = list()
	var/list/datum/mind/gangboss_candidates = list()

/datum/game_mode/gang/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	//Spawn more bosses depending on server population
	var/gangs_to_create = 2
	if(prob(num_players()) && num_players() > 1.5*required_players)
		gangs_to_create++
	if(prob(num_players()) && num_players() > 2*required_players)
		gangs_to_create++
	gangs_to_create = min(gangs_to_create, possible_gangs.len)

	for(var/i in 1 to gangs_to_create)
		if(!antag_candidates.len)
			break

		//Now assign a boss for the gang
		var/datum/mind/boss = pick(antag_candidates)
		antag_candidates -= boss
		gangboss_candidates += boss
		boss.restricted_roles = restricted_jobs

	if(gangboss_candidates.len < 2) //Need at least two gangs
		return 0

	return 1


/datum/game_mode/gang/post_setup()
	set waitfor = FALSE
	..()
	for(var/i in gangboss_candidates)
		var/datum/mind/M = i
		var/datum/team/gang/grove = pick_n_take(possible_gangs)
		if(grove)
			grove = new(M) // by passing M, it also makes M a boss and gives him the boss stuff
			gangs += grove
		else break


/datum/game_mode/proc/forge_gang_objectives(datum/mind/boss_mind)
	var/datum/objective/takeover = new
	takeover.owner = boss_mind
	takeover.explanation_text = "Be the first gang to successfully takeover the station with a Dominator."
	boss_mind.objectives += takeover

////////////////////////////////////////////////////////////////////
//Deals with players reverting to neutral (Not a gangster anymore)//
////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/remove_gangster(datum/mind/gangster_mind, beingborged, silent, remove_bosses=0)
	var/datum/team/gang/gang = has_antag_datum(/datum/antagonist/gang)
	if(!gang)
		return 0

	var/removed

	for(var/datum/gang/G in gangs)
		if(!G.is_deconvertible && !remove_bosses)
			return 0
		if(gangster_mind in G.gangsters)
			G.reclaim_points(G.gangsters[gangster_mind])
			G.gangsters -= gangster_mind
			removed = 1
		if(remove_bosses && (gangster_mind in G.bosses))
			G.reclaim_points(G.bosses[gangster_mind])
			G.bosses -= gangster_mind
			removed = 1
		if(G.tags_by_mind[gangster_mind] && islist(G.tags_by_mind[gangster_mind]))
			var/list/tags_cache = G.tags_by_mind[gangster_mind]
			for(var/v in tags_cache)
				var/obj/effect/decal/cleanable/crayon/gang/c = v
				c.set_mind_owner(null)
			G.tags_by_mind -= gangster_mind

	if(!removed)
		return 0


	gangster_mind.special_role = null
	gangster_mind.gang_datum = null

	if(silent < 2)
		gangster_mind.current.log_message("<font color='red'>Has reformed and defected from the [gang.name] Gang!</font>", INDIVIDUAL_ATTACK_LOG)

		if(beingborged)
			if(!silent)
				gangster_mind.current.visible_message("The frame beeps contentedly from the MMI before initalizing it.")
			to_chat(gangster_mind.current, "<FONT size=3 color=red><B>The frame's firmware detects and deletes your criminal behavior! You are no longer a gangster!</B></FONT>")
			message_admins("[ADMIN_LOOKUPFLW(gangster_mind.current)] has been borged while being a member of the [gang.name] Gang. They are no longer a gangster.")
		else
			if(!silent)
				gangster_mind.current.Unconscious(100)
				gangster_mind.current.visible_message("<FONT size=3><B>[gangster_mind.current] looks like they've given up the life of crime!<B></font>")
			to_chat(gangster_mind.current, "<FONT size=3 color=red><B>You have been reformed! You are no longer a gangster!</B><BR>You try as hard as you can, but you can't seem to recall any of the identities of your former gangsters...</FONT>")
			gangster_mind.memory = ""

	gang.remove_gang_hud(gangster_mind)
	return 1

////////////////
//Helper Procs//
////////////////

/datum/game_mode/proc/get_all_gangsters()
	var/list/all_gangsters = list()
	all_gangsters += get_gangsters()
	all_gangsters += get_gang_bosses()
	return all_gangsters

/datum/game_mode/proc/get_gangsters()
	var/list/gangsters = list()
	for(var/datum/gang/G in gangs)
		gangsters += G.gangsters
	return gangsters

/datum/game_mode/proc/get_gang_bosses()
	var/list/gang_bosses = list()
	for(var/datum/gang/G in gangs)
		gang_bosses += G.bosses
	return gang_bosses

/datum/game_mode/proc/shuttle_check()
	if(SSshuttle.emergencyNoRecall)
		return
	var/alive = 0
	for(var/mob/living/L in GLOB.player_list)
		if(L.stat != DEAD)
			alive++

	if((alive < (GLOB.joined_player_list.len * 0.4)) && ((SSshuttle.emergency.timeLeft(1) > (SSshuttle.emergencyCallTime * 0.4))))

		SSshuttle.emergencyNoRecall = TRUE
		SSshuttle.emergency.request(null, set_coefficient = 0.4)
		priority_announce("Catastrophic casualties detected: crisis shuttle protocols activated - jamming recall signals across all frequencies.")

/proc/determine_domination_time(var/datum/gang/G)
	return max(180,480 - (round((G.territory.len/GLOB.start_state.num_territories)*100, 1) * 9))


//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relavent information stated//
//////////////////////////////////////////////////////////////////////

/datum/game_mode/proc/auto_declare_completion_gang(datum/gang/winner)
	if(!gangs.len)
		return
	if(!winner)
		to_chat(world, "<span class='redtext'>The station was [station_was_nuked ? "destroyed!" : "evacuated before a gang could claim it! The station wins!"]</span><br>")
		SSticker.mode_result = "loss - gangs failed takeover"

		SSticker.news_report = GANG_LOSS
	else
		to_chat(world, "<span class='redtext'>The [winner.name] Gang successfully performed a hostile takeover of the station!</span><br>")
		SSticker.mode_result = "win - gang domination complete"

		SSticker.news_report = GANG_TAKEOVER

	for(var/datum/gang/G in gangs)
		var/text = "<b>The [G.name] Gang was [winner==G ? "<span class='greenannounce'>victorious</span>" : "<span class='boldannounce'>defeated</span>"] with [round((G.territory.len/GLOB.start_state.num_territories)*100, 1)]% control of the station!</b>"
		text += "<br>The [G.name] Gang Bosses were:"
		for(var/datum/mind/boss in G.bosses)
			text += printplayer(boss, 1)
		text += "<br>The [G.name] Gangsters were:"
		for(var/datum/mind/gangster in G.gangsters)
			text += printplayer(gangster, 1)
		text += "<br>"
		to_chat(world, text)

//////////////////////////////////////////////////////////
//Handles influence, territories, and the victory checks//
//////////////////////////////////////////////////////////


/datum/game_mode/gang/generate_credit_text()
	var/list/round_credits = list()
	var/len_before_addition

	for(var/datum/gang/G in gangs)
		round_credits += "<center><h1>The [G.name] Gang:</h1>"
		len_before_addition = round_credits.len
		for(var/datum/mind/boss in G.bosses)
			round_credits += "<center><h2>[boss.name] as a [G.name] Gang leader</h2>"
		for(var/datum/mind/gangster in G.gangsters)
			round_credits += "<center><h2>[gangster.name] as a [G.name] gangster</h2>"
		if(len_before_addition == round_credits.len)
			round_credits += list("<center><h2>The [G.name] Gang was wiped out!</h2>", "<center><h2>The competition was too tough!</h2>")
		round_credits += "<br>"

	round_credits += ..()
	return round_credits