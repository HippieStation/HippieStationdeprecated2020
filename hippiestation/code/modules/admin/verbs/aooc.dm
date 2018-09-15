/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	if(!check_rights(R_ADMIN))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	msg = emoji_parse(msg)

	var/display_name = src.key
	if(holder && holder.fakekey)
		display_name = holder.fakekey

	for(var/X in GLOB.clients)
		var/client/C = X
		if(check_rights_for(C, R_ADMIN) || (C.mob.mind && islist(C.mob.mind.antag_datums) && C.mob.mind.antag_datums.len) || istype(C.mob, /mob/dead/observer))
			to_chat(C, "<font color='#960018'><span class='ooc'><span class='prefix'>ANTAG OOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

	log_ooc("(ANTAG) [key] : [msg]")