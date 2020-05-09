/atom
	var/icon_hippie
	var/next_spam_shot = 0

/atom/proc/check_hippie_icon()
	if (!icon || !icon_state || !icon_hippie)
		return
	if (length(icon_hippie) <= 0)
		return
	if (!is_string_in_list(icon_state, icon_states(icon_hippie)))
		return
	icon = icon_hippie

/atom/Initialize()
	. = ..()
	check_hippie_icon()


/atom/MouseMove(location, control, params)
	..()
	if(get_dist(usr,src) <= 10 && usr.client.prefs.mouseaim) 
		return usr.face_atom(src)
	if(!(usr.client.prefs.mouseaim))
		return 0
