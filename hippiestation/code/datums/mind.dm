/datum/mind/proc/remove_shadowling()
	if(is_thrall(current))
		remove_thrall(src)
	if(is_shadow(current))
		remove_shadowling(src)

/datum/mind/remove_all_antag()
	. = ..()
	remove_shadowling()


/datum/mind/proc/vampire_hook()
	var/text = "vampire"
	if(SSticker.mode.config_tag == "vampire")
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if(is_vampire(current))
		text += "<b>VAMPIRE</b> | <a href='?src=[REF(src)];vampire=clear'>human</a> | <a href='?src=[REF(src)];vampire=full'>full-power</a>"
	else
		text += "<a href='?src=[REF(src)];vampire=vampire'>vampire</a> | <b>HUMAN</b> | <a href='?src=[REF(src)];vampire=full'>full-power</a>"
	if(current && current.client && (ROLE_VAMPIRE in current.client.prefs.be_special))
		text += " | Enabled in Prefs"
	else
		text += " | Disabled in Prefs"
	return text

/datum/mind/proc/sling_hook()
	var/text = "shadowling"
	if(SSticker.mode.config_tag == "shadowling")
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if(is_shadow(current))
		text += "<b>SHADOWLING</b> | thrall | <a href='?src=[REF(src)];shadowling=clear'>human</a>"
	else if(is_thrall(current))
		text += "shadowling | <b>THRALL</b> | <a href='?src=[REF(src)];shadowling=clear'>human</a>"
	else
		text += "<a href='?src=[REF(src)];shadowling=shadowling'>shadowling</a>	 | <a href='?src=[REF(src)];shadowling=thrall'>thrall</a> | <b>HUMAN</b>"

	if(current && current.client && (ROLE_SHADOWLING in current.client.prefs.be_special))
		text += " | Enabled in Prefs"
	else
		text += " | Disabled in Prefs"
	return text


/datum/mind/proc/vampire_href(href, mob/M)
	switch(href)
		if("clear")
			remove_vampire(current)
			message_admins("[key_name_admin(M)] has de-vampired [current].")
			log_admin("[key_name(M)] has de-vampired [current].")
		if("vampire")
			if(!is_vampire(current))
				message_admins("[key_name_admin(M)] has vampired [current].")
				log_admin("[key_name(M)] has vampired [current].")
				add_vampire(current)
			else
				to_chat(usr, "<span class='warning'>[current] is already a vampire!</span>")
		if("full")
			message_admins("[key_name_admin(M)] has full-vampired [current].")
			log_admin("[key_name(usr)] has full-vampired [current].")
			if(!is_vampire(current))
				add_vampire(current)
				var/datum/antagonist/vampire/V = has_antag_datum(ANTAG_DATUM_VAMPIRE)
				if(V)
					V.total_blood = 1500
					V.usable_blood = 1500
					V.check_vampire_upgrade()
			else
				var/datum/antagonist/vampire/V = has_antag_datum(ANTAG_DATUM_VAMPIRE)
				if(V)
					V.total_blood = 1500
					V.usable_blood = 1500
					V.check_vampire_upgrade()

/datum/mind/proc/sling_href(href, mob/M)
	switch(href)
		if("clear")
			if(is_shadow(current))
				remove_sling(src)
				message_admins("[key_name_admin(M)] has de-shadowling'ed [current].")
				log_admin("[key_name(M)] has de-shadowling'ed [current].")
			else if(is_thrall(current))
				remove_thrall(src)
				message_admins("[key_name_admin(M)] has de-thrall'ed [current].")
				log_admin("[key_name(M)] has de-thrall'ed [current].")
		if("shadowling")
			if(!ishuman(current))
				to_chat(usr, "<span class='warning'>This only works on humans!</span>")
				return
			add_sling(src)
			message_admins("[key_name_admin(M)] has shadowling'ed [current].")
			log_admin("[key_name(M)] has shadowling'ed [current].")
		if("thrall")
			if(!ishuman(current))
				to_chat(usr, "<span class='warning'>This only works on humans!</span>")
				return
			add_thrall(src)
			message_admins("[key_name_admin(M)] has thrall'ed [current].")
			log_admin("[key_name(M)] has thrall'ed [current].")