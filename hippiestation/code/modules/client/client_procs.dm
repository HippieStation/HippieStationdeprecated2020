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

/client/New(TopicData)
	. = ..()
	if (byond_version < 512)
		to_chat(src, "<span class='userdanger'><b>USE BYOND 512, FUCKTARD!</b></span>")
