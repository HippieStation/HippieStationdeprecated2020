/mob/Login()
	..()
	for(var/i in GLOB.donators)
		if(ckey(i) == client.ckey)
			client.is_donator = TRUE
			return