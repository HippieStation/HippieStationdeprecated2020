/atom
    var/icon_hippie

/atom/proc/check_hippie_icon()
    if (!icon_hippie)
        return FALSE

    var/hippie_icon_ok = TRUE
    var/icon/I = new (icon_hippie)

    if (length(icon_hippie) <= 0)
        hippie_icon_ok = FALSE
    else if (!is_string_in_list(icon_state, icon_states(I)))
        hippie_icon_ok = FALSE

    if (hippie_icon_ok)
        icon = icon_hippie

    return hippie_icon_ok

/atom/Initialize()
    if (icon && icon_state && icon_hippie)
        check_hippie_icon()
    return ..()