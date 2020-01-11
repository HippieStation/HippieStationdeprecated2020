/datum/admins/proc/HippieMentorLogSecret()
	var/dat = "<B>Mentor Log<HR></B>"
	for(var/l in GLOB.mentorlog)
		dat += "<li>[l]</li>"

	if(!GLOB.mentorlog.len)
		dat += "No mentors have done anything this round!"
	usr << browse(dat, "window=mentor_log")

/datum/admins/Secrets_topic(item,href_list)
	. = ..()
	if (item == "winter")
		if(href_list["toggle"])
			StartWinter()
		else
			StopWinter()
