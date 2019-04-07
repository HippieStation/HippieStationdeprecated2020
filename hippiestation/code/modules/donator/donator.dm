GLOBAL_LIST_EMPTY(donators)
GLOBAL_PROTECT(donators)

/proc/load_donators()
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_load_donators = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("donators")]")
		if(!query_load_donators.Execute())
			qdel(query_load_donators)
			return
		while(query_load_donators.NextRow())
			var/donator_ckey = query_load_donators.item[1]
			GLOB.donators += lowertext("[donator_ckey]")
		qdel(query_load_donators)
	else
		log_world("Failed to connect to database in load_donators(). Reverting to legacy system.")
		WRITE_FILE(GLOB.world_game_log, "Failed to connect to database in load_donators(). Reverting to legacy system.")
		var/list/lines = world.file2list("config/donators.txt")
		for(var/line in lines)
			if(!length(line))
				continue
			if(findtextEx(line, "#", 1, 2))
				continue
			GLOB.donators += lowertext("[line]")

/client
	var/is_donator = FALSE

/client/proc/addDonator()
	set category = "Admin"
	set name = "Make donator"
	var/ckeyvalue = input(src, "Input the ckey of the person you want to make a donator.", "Make donator")
	if(ckeyvalue)
		var/datum/admins/A = usr.client.holder
		A?.makeDonator(ckeyvalue)

/client/proc/deleteDonator()
	set category = "Admin"
	set name = "Remove donator"
	var/ckeyvalue = input(src, "Input the ckey of the person you want to remove as donator.", "Remove donator")
	if(ckeyvalue)
		var/datum/admins/A = usr.client.holder
		A?.removeDonator(ckeyvalue)