/client/Topic/proc/HippieMentorMessage()
	if(config.mentors_mobname_only)
		var/mob/M = locate(href_list["mentor_msg"])
		cmd_mentor_pm(M,null)
	else
		cmd_mentor_pm(href_list["mentor_msg"],null)

/client/Topic/proc/HippieMentorFollow()
	var/mob/living/M = locate(href_list["mentor_follow"])

	if(istype(M))
		mentor_follow(M)

/client/proc/do_mhelp()
	var/mhl = alert("Your message \"[msg]\" looks like it was meant for mentorhelp, ahelp it?", "Meant for Adminhelp?", "No", "Yes", "Cancel")
	switch(mhl)
		if("No")
			mentorhelp(msg)
			return TRUE
		if("Cancel")
			return TRUE
	return FALSE
