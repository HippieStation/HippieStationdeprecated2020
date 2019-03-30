/mob/Login()
	..()
	for(var/donator in GLOB.donators)
		if(donator == computer_id)
			client.is_donator = TRUE
			return