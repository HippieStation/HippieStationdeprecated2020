/atom
	var/icon_hippie

/atom/proc/check_hippie_icon() // Removes safety checks for icon_hippie. If you somehow set this but forget to actually add the icon, you're a retard, and it should be easily viewable ingame.
	if (!icon || !icon_state || !icon_hippie)
		return
	icon = icon_hippie

/atom/Initialize()
    check_hippie_icon()
    return ..()