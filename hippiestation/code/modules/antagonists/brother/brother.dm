/datum/antagonist/brother/greet()
	var/brother_text = ""
	var/list/brothers = team.members - owner
	for(var/i = 1 to brothers.len)
		var/datum/mind/M = brothers[i]
		brother_text += M.name
		if(i == brothers.len - 1)
			brother_text += " and "
		else if(i != brothers.len)
			brother_text += ", "
	to_chat(owner.current, "<B><font size=3 color=red>You are the [owner.special_role] of [brother_text].</font></B>")
	to_chat(owner.current, "The Syndicate only accepts those that have proven themself. Prove yourself and prove your [team.member_name]s by completing your objectives together!")
	owner.announce_objectives()
	give_meeting_area()
	owner.current.playsound_local(get_turf(owner.current), 'hippiestation/sound/ambience/antag/brother.ogg',80,0)  
