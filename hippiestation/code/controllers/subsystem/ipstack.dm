SUBSYSTEM_DEF(ipstack)
	name = "GeoIP"
	init_order = INIT_ORDER_XKEYSCORE
	flags = SS_NO_FIRE

	var/list/cache = list()

/datum/controller/subsystem/ipstack/proc/check_ip(ip)
	if(!ip)
		return "???"
	if(cache[ip])
		return cache[ip]
	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_ip = SSdbcore.NewQuery({"
			SELECT country
			FROM [format_table_name("ipstack")]
			WHERE
				ip = INET_ATON('[ip]')"})
		if(!query_get_ip.Execute())
			qdel(query_get_ip)
			return "???"
		if (query_get_ip.NextRow())
			var/country = query_get_ip.item[1]
			if(country)
				cache[ip] = country
				qdel(query_get_ip)
				return country
		qdel(query_get_ip)
	return fetch_ip(ip)

/datum/controller/subsystem/ipstack/proc/fetch_ip(ip)
	if(!ip)
		return "???"
	if(cache[ip])
		return cache[ip]
	if(!CONFIG_GET(string/ipstack_api_key))
		return "???"
	var/list/http[] = world.Export("http://api.ipstack.com/[ip]?access_key=[CONFIG_GET(string/ipstack_api_key)]")
	if(http)
		var/status = text2num(http["STATUS"])
		if(status == 200)
			var/response = json_decode(file2text(http["CONTENT"]))
			if(response && response["country_name"])
				var/country = response["country_name"]
				cache[ip] = country
				var/datum/DBQuery/query_add_ip = SSdbcore.NewQuery("INSERT INTO [format_table_name("ipstack")] (ip, country) VALUES (INET_ATON('[ip]'), '[sanitizeSQL(country)]')")
				query_add_ip.Execute()
				qdel(query_add_ip)
				return country
			else
				return "???"
		else
			return "???"
	else
		return "???"
