/client/verb/forumlink()
	set name = "Link Forum"
	set desc = "Link your BYOND key with your forum account"
	set category = "OOC"

	if(!CONFIG_GET(string/token_generator))
		to_chat(usr, "<span class='danger'>The token generator URL is not set in the server configuration.</span>")
		return

	if(!CONFIG_GET(string/token_consumer))
		to_chat(usr, "<span class='danger'>The token consumer URL is not set in the server configuration.</span>")
		return

	if(alert("This will open the forums in your browser. Are you sure?",,"Yes","No")=="No")
		return

	log_admin("[key_name(src)] is linking their forum account")
	message_admins("[key_name_admin(src)] is linking their forum account")

	var/payload = url_encode(src.key)
	var/http[] = world.Export("[CONFIG_GET(string/token_generator)]?ckey=[payload]")
	if(!http)
		to_chat(src, "<span class='danger'>Token generator server is down. Please try again later, if this issue persists contact an admin.</span>")
		return

	var/F = file2text(http["CONTENT"])
	if(F)
		src << link("[CONFIG_GET(string/token_consumer)]?token=[F]")
	else
		to_chat(src, "<span class='danger'>Token generator server is experiencing issues. Please try again later, if this issue persists contact an admin.</span>")
		return