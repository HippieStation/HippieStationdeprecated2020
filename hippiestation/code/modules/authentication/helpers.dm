/proc/get_correct_key(user)
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_key = SSdbcore.NewQuery({"
			SELECT `key`
			FROM [format_table_name("authentication")]
			WHERE
				ckey = '[sanitizeSQL(ckey(user))]'"})
		if(!query_get_key.Execute())
			qdel(query_get_key)
			return
		if (query_get_key.NextRow())
			var/actual_key = query_get_key.item[1]
			if(actual_key)
				qdel(query_get_key)
				return actual_key
		qdel(query_get_key)
