/mob/dead/unauthed/Login()
	..()
	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)
	if(GLOB.admin_notice)
		to_chat(src, "<span class='notice'><b>Admin Notice:</b>\n \t [GLOB.admin_notice]</span>")
	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, "<span class='notice'><b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]</span>")
	sight |= SEE_TURFS
	if(!GLOB.tffi_loaded)
		to_chat(src, "<span class='big danger'>Warning: authentication is currently offline. Please contact admins.</span>")
	auth_setup()
