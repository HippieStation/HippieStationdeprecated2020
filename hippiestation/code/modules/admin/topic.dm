/datum/admins/proc/hippie_makeShadowling(datum/admins/sr)
	if(sr.makeShadowling())
		message_admins("[key_name(usr)] created a shadowling.")
		log_admin("[key_name(usr)] created a shadowling.")
	else
		message_admins("[key_name_admin(usr)] tried to create a shadowling. Unfortunately, there were no candidates available.")
		log_admin("[key_name(usr)] failed to create a shadowling.")

/datum/admins/proc/hippie_makeVampire(datum/admins/sr)
	if(sr.makeVampire())
		message_admins("[key_name(usr)] created a vampire.")
		log_admin("[key_name(usr)] created a vampire.")
	else
		message_admins("[key_name_admin(usr)] tried to create a vampire. Unfortunately, there were no candidates available.")
		log_admin("[key_name(usr)] failed to create a vampire.")

/datum/admins/proc/hippie_makeJesus(datum/admins/sr)
	if(sr.makeJesus())
		message_admins("[key_name(usr)] created a messiah.")
		log_admin("[key_name(usr)] created a messiah.")
	else
		message_admins("[key_name_admin(usr)] tried to create a messiah. Unfortunately, there were no candidates available.")
		log_admin("[key_name(usr)] failed to create a messiah.")

/datum/admins/proc/hippie_makeInfiltrators(datum/admins/sr)
	message_admins("[key_name(usr)] is creating an infiltration team...")
	if(sr.makeInfiltratorTeam())
		message_admins("[key_name(usr)] created an infiltration team.")
		log_admin("[key_name(usr)] created an infiltration team.")
	else
		message_admins("[key_name_admin(usr)] tried to create an infiltration team. Unfortunately, there were not enough candidates available.")
		log_admin("[key_name(usr)] failed to create an infiltration team.")

/datum/admins/proc/hippieTopic(href, href_list)
	if(href_list["makeAntag"] == "shadowling")
		hippie_makeShadowling(src)
	else if(href_list["makeAntag"] == "vampire")
		hippie_makeVampire(src)
	else if(href_list["makeAntag"] == "messiah")
		hippie_makeJesus(src)
	else if(href_list["makeAntag"] == "infiltrator")
		hippie_makeInfiltrators(src)
	else if(href_list["makementor"])
		makeMentor(href_list["makementor"])
	else if(href_list["removementor"])
		removeMentor(href_list["removementor"])
	else if(href_list["mentormemoeditlist"])
		checkMentorEditList(href_list["mentormemoeditlist"])
	else if(href_list["makedonator"])
		makeDonator(href_list["makedonator"])
	else if(href_list["removedonator"])
		removeDonator(href_list["removedonator"])

/datum/admins/proc/checkMentorEditList(ckey)
	var/sql_key = sanitizeSQL("[ckey]")
	var/datum/DBQuery/query_memoedits = SSdbcore.NewQuery("SELECT edits FROM [format_table_name("mentor_memo")] WHERE (ckey = '[sql_key]')")
	if(!query_memoedits.warn_execute())
		qdel(query_memoedits)
		return
	if(query_memoedits.NextRow())
		var/edit_log = query_memoedits.item[1]
		usr << browse(edit_log,"window=mentormemoeditlist")
	qdel(query_memoedits)

/datum/admins/proc/makeMentor(ckey)
	if(!usr.client)
		return
	if (!check_rights(0))
		return
	if(!ckey)
		return
	var/client/C = GLOB.directory[ckey]
	if(C)
		if(check_rights_for(C, R_ADMIN,0))
			to_chat(usr, "<span class='danger'>The client chosen is an admin! Cannot mentorize.</span>")
			return
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_mentor = SSdbcore.NewQuery("SELECT id FROM [format_table_name("mentor")] WHERE ckey = '[ckey]'")
		if(query_get_mentor.NextRow())
			to_chat(usr, "<span class='danger'>[ckey] is already a mentor.</span>")
			qdel(query_get_mentor)
			return
		var/datum/DBQuery/query_add_mentor = SSdbcore.NewQuery("INSERT INTO `[format_table_name("mentor")]` (`id`, `ckey`) VALUES (null, '[ckey]')")
		if(!query_add_mentor.warn_execute())
			qdel(query_get_mentor)
			qdel(query_add_mentor)
			return
		var/datum/DBQuery/query_add_admin_log = SSdbcore.NewQuery("INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log) VALUES ('[SQLtime()]', '[GLOB.round_id]', '[sanitizeSQL(usr.ckey)]', INET_ATON('[sanitizeSQL(usr.client.address)]'), 'add rank', '[sanitizeSQL(ckey)]', 'New mentor added: [sanitizeSQL(ckey)]');")
		if(!query_add_admin_log.warn_execute())
			qdel(query_get_mentor)
			qdel(query_add_mentor)
			qdel(query_add_admin_log)
			return
		qdel(query_get_mentor)
		qdel(query_add_mentor)
		qdel(query_add_admin_log)
	else
		to_chat(usr, "<span class='danger'>Failed to establish database connection. The changes will last only for the current round.</span>")
	new /datum/mentors(ckey)
	to_chat(usr, "<span class='adminnotice'>New mentor added.</span>")

/datum/admins/proc/removeMentor(ckey)
	if(!usr.client)
		return
	if (!check_rights(0))
		return
	if(!ckey)
		return
	var/client/C = GLOB.directory[ckey]
	if(C)
		if(check_rights_for(C, R_ADMIN,0))
			to_chat(usr, "<span class='danger'>The client chosen is an admin, not a mentor! Cannot de-mentorize.</span>")
			return
		C.remove_mentor_verbs()
		C.mentor_datum = null
		GLOB.mentors -= C
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_remove_mentor = SSdbcore.NewQuery("DELETE FROM [format_table_name("mentor")] WHERE ckey = '[ckey]'")
		if(!query_remove_mentor.warn_execute())
			qdel(query_remove_mentor)
			return
		var/datum/DBQuery/query_add_admin_log = SSdbcore.NewQuery("INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log) VALUES ('[SQLtime()]', '[GLOB.round_id]', '[sanitizeSQL(usr.ckey)]', INET_ATON('[sanitizeSQL(usr.client.address)]'), 'remove rank', '[sanitizeSQL(ckey)]', 'Mentor removed: [sanitizeSQL(ckey)]');")
		if(!query_add_admin_log.warn_execute())
			qdel(query_remove_mentor)
			qdel(query_add_admin_log)
			return
		qdel(query_remove_mentor)
		qdel(query_add_admin_log)
	else
		to_chat(usr, "<span class='danger'>Failed to establish database connection. The changes will last only for the current round.</span>")
	to_chat(usr, "<span class='adminnotice'>Mentor removed.</span>")

/datum/admins/proc/hippie_on_jobban(mob/M, list/joblist)
	if(joblist.len && (CATBAN in joblist) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.set_species(/datum/species/tarajan, icon_update=1) // can't escape hell

/datum/admins/proc/makeDonator(ckey)
	var/makedonator = FALSE
	if(!ckey)
		return
	var/client/C = GLOB.directory[ckey]
	ckey = lowertext("[ckey]")
	if("[ckey]" in GLOB.donators)
		to_chat(usr, "<span class='danger'>[ckey] is already a donator!")
		log_admin("[key_name(usr)] tried to make [ckey] into a donator but they were already a donator.")
		return
	if(SSdbcore.Connect())
		ckey = sanitizeSQL(ckey)
		var/datum/DBQuery/query_add_donator = SSdbcore.NewQuery("INSERT INTO [format_table_name("donators")] (`ckey`) VALUES ('[ckey]')")
		if(!query_add_donator.warn_execute())
			qdel(query_add_donator)
			return
		GLOB.donators += "[ckey]"
		makedonator = TRUE
		message_admins("[ckey] has been made into a donator by [key_name_admin(usr)].")
		log_admin("[key_name(usr)] made [ckey] into a donator.")
		qdel(query_add_donator)
	else
		GLOB.donators += "[ckey]"
		makedonator = TRUE
		if(isfile(file("config/donators.txt")))
			text2file("[ckey]", "config/donators.txt")
			message_admins("[ckey] has been made into a donator in donators.txt by [key_name_admin(usr)].")
			log_admin("[key_name(usr)] made [ckey] into a donator in donators.txt")
		else
			message_admins("[ckey] has been made into a temporary donator by [key_name_admin(usr)], as the database is not connected.")
			log_admin("[key_name(usr)] made [ckey] into a temporary donator, as the database was not connected.")
	if(C && makedonator)
		C.is_donator = TRUE
		to_chat(C, "<span class='notice'>You have been made a donator!")

/datum/admins/proc/removeDonator(ckey)
	var/removedonator = FALSE
	if(!ckey)
		return
	var/client/C = GLOB.directory[ckey]
	ckey = lowertext("[ckey]")
	if(!("[ckey]" in GLOB.donators))
		to_chat(usr, "<span class='danger'>[ckey] is not a donator!</span>")
		log_admin("[key_name(usr)] tried to remove [ckey] as a donator but they were not a donator.")
		return
	if(SSdbcore.Connect())
		ckey = sanitizeSQL(ckey)
		var/datum/DBQuery/query_remove_donator = SSdbcore.NewQuery("DELETE FROM [format_table_name("donators")] WHERE ckey = '[ckey]'")
		if(!query_remove_donator.warn_execute())
			qdel(query_remove_donator)
			return
		GLOB.donators -= "[ckey]"
		removedonator = TRUE
		message_admins("[ckey] has been removed as a donator by [key_name_admin(usr)].")
		log_admin("[key_name(usr)] removed [ckey] as a donator.")
		qdel(query_remove_donator)
	else
		GLOB.donators -= "[ckey]"
		removedonator = TRUE
		if(isfile(file("config/donators.txt")))
			var/list/textlines = world.file2list("config/donators.txt")
			for(var/word in textlines)
				if(!length(word))
					continue
				if(ckey == word)
					textlines -= word
			fdel("config/donators.txt")	//god bless this exists
			text2file(jointext(textlines, "\n"), "config/donators.txt")
			message_admins("[ckey] has been removed as a donator in donators.txt by [key_name_admin(usr)].")
			log_admin("[key_name(usr)] removed [ckey] as a donator in donators.txt.")
			qdel(textlines)
		else
			message_admins("[ckey] has been temporarily removed as a donator by [key_name_admin(usr)], as the database is not connected.")
			log_admin("[key_name(usr)] temporarily removed [ckey] as a donator, as the database was not connected.")
	if(C && removedonator)
		C.is_donator = FALSE
		to_chat(C, "<span class='danger'>You have been removed as a donator!")