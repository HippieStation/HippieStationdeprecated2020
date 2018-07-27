//gang.dm
//Gang War Game Mode
GLOBAL_LIST_INIT(possible_gangs, subtypesof(/datum/team/gang))
GLOBAL_LIST_EMPTY(gangs)
/datum/game_mode/gang
	name = "gang war"
	config_tag = "gang"
	antag_flag = ROLE_GANG
	restricted_jobs = list("Security Officer", "Warden", "Detective", "AI", "Cyborg","Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer")
	required_players = 1 //15
	required_enemies = 1 // 2
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
	var/gangs_to_create = 1//2
	if(prob(num_players()) && num_players() > 1.5*required_players)
		gangs_to_create++
	if(prob(num_players()) && num_players() > 2*required_players)
		gangs_to_create++
	gangs_to_create = min(gangs_to_create, GLOB.possible_gangs.len)

	for(var/i in 1 to gangs_to_create)
		if(!antag_candidates.len)
			break

		//Now assign a boss for the gang
		var/datum/mind/boss = pick(antag_candidates)
		antag_candidates -= boss
		gangboss_candidates += boss
		boss.restricted_roles = restricted_jobs

	if(gangboss_candidates.len < 1) //Need at least two gangs
		return

	return TRUE


/datum/game_mode/gang/post_setup()
	set waitfor = FALSE
	..()
	for(var/i in gangboss_candidates)
		var/datum/mind/M = i
		var/datum/antagonist/gang/boss/B = new()
		M.add_antag_datum(B)
		B.equip_gang()


/datum/game_mode/proc/forge_gang_objectives(datum/mind/boss_mind)
	var/datum/objective/takeover = new
	takeover.owner = boss_mind
	takeover.explanation_text = "Be the first gang to successfully takeover the station with a Dominator."
	boss_mind.objectives += takeover

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

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relavent information stated//
//////////////////////////////////////////////////////////////////////

/datum/game_mode/proc/auto_declare_completion_gang(datum/team/gang/winner)
	if(!GLOB.gangs.len)
		return
	if(!winner)
		to_chat(world, "<span class='redtext'>The station was [station_was_nuked ? "destroyed!" : "evacuated before a gang could claim it! The station wins!"]</span><br>")
		SSticker.mode_result = "loss - gangs failed takeover"

		SSticker.news_report = GANG_LOSS
	else
		to_chat(world, "<span class='redtext'>The [winner.name] Gang successfully performed a hostile takeover of the station!</span><br>")
		SSticker.mode_result = "win - gang domination complete"

		SSticker.news_report = GANG_TAKEOVER

	for(var/datum/team/gang/G in GLOB.gangs)
		var/text = "<b>The [G.name] Gang was [winner==G ? "<span class='greenannounce'>victorious</span>" : "<span class='boldannounce'>defeated</span>"]!</b>"
		text += "<br>The [G.name] Gang Bosses were:"
		for(var/datum/mind/boss in G.leaders)
			text += printplayer(boss, 1)
		text += "<br>The [G.name] Gangsters were:"
		for(var/datum/mind/gangster in G.members - G.leaders)
			text += printplayer(gangster, 1)
		text += "<br>"
		to_chat(world, text)
