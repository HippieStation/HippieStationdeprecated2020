/client/cmd_admin_rejuvenate(mob/living/M in GLOB.mob_list)
	..()
	M.unascend_animation()
	M.visible_message("<span class='warning bold'>[M] was healed by divine intervention!</span>")

/client/proc/toggle_antag_tokens()
	set category = "Server"
	set name = "Toggle Antag Tokens on/off"
	set desc = "Toggles whether antag tokens can be used or not."
	GLOB.allow_antag_tokens = !GLOB.allow_antag_tokens
	if(GLOB.allow_antag_tokens)
		to_chat(usr, "Antag Tokens enabled")
		message_admins("Admin [key_name_admin(usr)] has enabled Antag Tokens.")
	else
		to_chat(usr, "Antag Tokens disabled")
		message_admins("Admin [key_name_admin(usr)] has disabled Antag Tokens.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Antag Tokens", "[GLOB.allow_antag_tokens ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
