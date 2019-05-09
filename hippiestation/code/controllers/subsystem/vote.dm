datum/controller/subsystem/vote
	var/min_restart_time = 60 MINUTES
	var/min_shuttle_time = 30 MINUTES

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(flag/default_no_vote) && choices.len)
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "restart")
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
			if(mode == "shuttlecall")
				if(choices["Do not call Shuttle"] >= greatest_votes)
					greatest_votes = choices["Do not call Shuttle"]
			if(mode == "gamemode")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters.len
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key)
	if(!mode)
		if(started_time)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, "<span class='warning'>There is already a vote in progress! please wait for it to finish.</span>")
				return 0

			var/admin = FALSE
			var/ckey = ckey(initiator_key)
			if(GLOB.admin_datums[ckey])
				admin = TRUE

			if(next_allowed_time > world.time && !admin)
				to_chat(usr, "<span class='warning'>A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!</span>")
				return 0

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round","Continue Playing")
			if("shuttlecall")
				choices.Add("Call Shuttle","Do not call Shuttle")
			if("gamemode")
				choices.Add(config.votable_modes)
			if("custom")
				question = stripped_input(usr,"What is the vote for?")
				if(!question)
					return 0
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr,"Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return 0
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "<div style='font-size: 28px'>[capitalize(mode)] vote started by [initiator].</div>"
		if(mode == "custom")
			text += "<div style='font-size: 18px'>\n[question]</div>"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		to_chat(world, "\n<font color='purple'><b>[text]</b>\n<div style='font-size: 18px'>Type <b>vote</b> or click <a href='?src=[REF(src)]'>here</a> to place your votes.\nYou have [DisplayTimeText(vp)] to vote.</font></div>")
		SEND_SOUND(world, sound('sound/ai/attention.ogg'))
		time_remaining = round(vp/10)
		for(var/c in GLOB.clients)
			var/client/C = c
			var/datum/action/vote/V = new
			if(question)
				V.name = "Vote: [question]"
			C.player_details.player_actions += V
			V.Grant(C.mob)
			generated_actions += V
		return 1
	return 0

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = 0
	var/trialmin = 0
	if(C.holder)
		admin = 1
		if(check_rights_for(C, R_ADMIN))
			trialmin = 1
	voting |= C

	if(mode)
		if(question)
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
		. += "Time Left: [time_remaining] s<hr><ul>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			. += "<li><a href='?src=[REF(src)];vote=[i]'>[choices[i]]</a> ([votes] votes)</li>"
		. += "</ul><hr>"
		if(admin)
			. += "(<a href='?src=[REF(src)];vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"
		//restart
		var/avr = CONFIG_GET(flag/allow_vote_restart)
		if(trialmin || avr)
			. += "<a href='?src=[REF(src)];vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_restart'>[avr ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"
		//callshuttle
		var/avg = CONFIG_GET(flag/allow_vote_shuttlecall)
		if(trialmin || avg)	//BEST ANTIVIRUS GET IT TODAY!!
			. += "<a href='?src=[REF(src)];vote=shuttlecall'>Call Shuttle</a>"
		else
			. += "<font color='grey'>Call Shuttle (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_shuttlecall'>[avg ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"
		//gamemode
		var/avm = CONFIG_GET(flag/allow_vote_mode)
		if(trialmin || avm)
			. += "<a href='?src=[REF(src)];vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=[REF(src)];vote=toggle_gamemode'>[avm ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//custom
		if(trialmin)
			. += "<li><a href='?src=[REF(src)];vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='?src=[REF(src)];vote=close' style='position:absolute;right:50px'>Close</a>"
	return .

/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid
	switch(href_list["vote"])
		if("close")
			voting -= usr.client
			usr << browse(null, "window=vote")
			return
		if("cancel")
			if(usr.client.holder)
				reset()
		if("toggle_restart")
			if(usr.client.holder)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("toggle_shuttlecall")
			if(usr.client.holder)
				CONFIG_SET(flag/allow_vote_shuttlecall, !CONFIG_GET(flag/allow_vote_shuttlecall))
		if("toggle_gamemode")
			if(usr.client.holder)
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				if(min_restart_time < world.time)
					initiate_vote("restart",usr.key)
				else
					to_chat(usr, "<span style='boldannounce'>Restart can only initiate after [DisplayTimeText(min_restart_time)].</span>")
		if("shuttlecall")
			if(CONFIG_GET(flag/allow_vote_shuttlecall) || usr.client.holder)
				if(min_shuttle_time < world.time)
					initiate_vote("shuttlecall",usr.key)
				else
					to_chat(usr, "<span style='boldannounce'>Shuttle call can only initiate after [DisplayTimeText(min_shuttle_time)].</span>")
		if("gamemode")
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				initiate_vote("gamemode",usr.key)
		if("custom")
			if(usr.client.holder)
				initiate_vote("custom",usr.key)
		else
			submit_vote(round(text2num(href_list["vote"])))
	usr.vote()


/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	var/shuttlecall = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(GLOB.master_mode != .)
					SSticker.save_mode(.)
					if(SSticker.HasRoundStarted())
						restart = 1
					else
						GLOB.master_mode = .
			if("shuttlecall")
				if(. == "Call Shuttle")
					shuttlecall = 1
	if(restart)
		var/active_admins = 0
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_rights_for(C, R_SERVER))
				active_admins = 1
				break
		if(!active_admins)
			SSticker.Reboot("Restart vote successful.", "restart vote")
		else
			to_chat(world, "<span style='boldannounce'>Notice: Restart vote will not restart the server automatically because there are active admins on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been cancelled. If you wish, you may restart the server.")
	if(shuttlecall)
		var/shuttle_timer = SSshuttle.emergency.timeLeft()
		if(shuttle_timer >= 300 || (SSshuttle.emergency.mode != SHUTTLE_CALL && SSshuttle.emergency.mode != SHUTTLE_DOCKED && SSshuttle.emergency.mode != SHUTTLE_ESCAPE)) // hippie -- fix shuttle votes upping timers to 5 minutes
			if(SSshuttle.emergency.mode == SHUTTLE_CALL && shuttle_timer >= 300)	//Apparently doing the emergency request twice cancels the call so these check are just in case
				SSshuttle.emergency.setTimer(3000)
				priority_announce("The emergency shuttle will arrive in [SSshuttle.emergency.timeLeft()/60] minutes.")
			else if (SSshuttle.emergency.mode != SHUTTLE_CALL)
				SSshuttle.emergency.request()
				SSshuttle.emergency.setTimer(3000)
				priority_announce("The emergency shuttle will arrive in [SSshuttle.emergency.timeLeft()/60] minutes.")

			message_admins("The emergency shuttle has been force-called due to a successful shuttle call vote.")
		else
			to_chat(world, "<span style='boldannounce'>Notice: The shuttle vote has failed because the shuttle has already been called.</span>")

	return .

/datum/action/vote/proc/remove_from_client()
	if(owner)	//Fixes null.client runtimes
		if(owner.client)
			owner.client.player_details.player_actions -= src
		else if(owner.ckey)
			var/datum/player_details/P = GLOB.player_details[owner.ckey]
			if(P)
				P.player_actions -= src
