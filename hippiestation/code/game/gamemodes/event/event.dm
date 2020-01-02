/datum/game_mode/events
	name = "Eventful"
	config_tag = "event"
	required_players = 0
	var/danger_time = 20 MINUTES
	var/critical_time = 26 MINUTES
	var/round_start_delay = 3 MINUTES
	var/next_event_delay = 1.5 MINUTES
	var/next_event = 4 MINUTES
	var/started = FALSE
	announce_span = "danger"
	announce_text = "The current game mode is - Events!\n\
					
					<span class='notice'>Crew:</span> Stay alive!"
/datum/game_mode/events/process()
	if (round_start_delay > world.time)
		return
	else
		if (started == FALSE)
			priority_announce("We are testing a new improbability drive near your sector. Expect random events to occur at unfortunate times.","Central Command Higher Dimensional Affairs", 'hippiestation/sound/pyko/spanomalies.ogg') // hippie -- pykoai
			addtimer(CALLBACK(src, .proc/real_process), 50)
		started = TRUE

/datum/game_mode/events/proc/real_process()
	if (world.time > danger_time)
		next_event_delay = 1 MINUTES
	if (world.time > critical_time)
		next_event_delay = 0.5 MINUTES 

	if (world.time > next_event)
		next_event = world.time + next_event_delay
		//time to trigger an event
		var/datum/round_event_control/event = pick(SSevents.control)
		
		if (event.preRunEvent() == EVENT_CANT_RUN)
			//you got lucky, relent
			return
		else   
			event.random = TRUE
			event.runEvent()
		deadchat_broadcast("A random event has just been triggered! Next event is in [next_event_delay/10] seconds.")
		


/datum/game_mode/events/special_report()
	var/survivors = 0
	var/list/survivor_list = list()

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat != DEAD)
			survivors++

			if(player.onCentCom())
				survivor_list += "<span class='greentext'>[player.real_name] escaped to the safety of CentCom.</span>"
			else if(player.onSyndieBase())
				survivor_list += "<span class='greentext'>[player.real_name] escaped to the (relative) safety of Syndicate Space.</span>"
			else
				survivor_list += "<span class='neutraltext'>[player.real_name] survived but is stranded without any hope of rescue.</span>"

	if(survivors)
		return "<div class='panel greenborder'><span class='header'>The following survived :</span><br>[survivor_list.Join("<br>")]</div>"
	else
		return "<div class='panel redborder'><span class='redtext big'>Nobody survived!</span></div>"


/datum/game_mode/events/generate_report()
	return "Due to quantum bluespace effects and a testing of a finite improbability drive near your sector, strage anomalous events may take place on your station\
	at a rapid pace and cause mass damage."
