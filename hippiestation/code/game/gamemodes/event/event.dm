/datum/game_mode/events
	name = "Eventful"
	config_tag = "event"
	required_players = 5
	var/danger_time = 23 MINUTES
	var/critical_time = 30 MINUTES
	var/round_start_delay = 3 MINUTES
	var/next_event_delay = 3 MINUTES
	var/next_event = next_event_delay
	announce_span = "danger"
	announce_text = "The current game mode is - Events!\n\
					
					<span class='notice'>Crew:</span> Stay alive!"
/datum/game_mode/events/process()
	if (round_start_delay > world.time)
		return
	if (world.time - SSticker.round_start_time > next_event)
		next_event = world.time + next_event_delay
		if (danger_time)
			next_event -= 0.5 MINUTES
		if (critical_time)
			next_event -= 1.5 MINUTES 
		//time to trigger an event
		var/datum/round_event_control/event = pick(SSevents.control)
		
		if (event.preRunEvent() == EVENT_CANT_RUN)
			//you got lucky, relent
			return
		else   
			event.random = TRUE
			event.runEvent()


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
