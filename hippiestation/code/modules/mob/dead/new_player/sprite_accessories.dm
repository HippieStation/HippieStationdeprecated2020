/datum/sprite_accessory
    var/icon_hippie

/datum/sprite_accessory/proc/check_hippie_icon()
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

/datum/sprite_accessory/New()
    if (icon && icon_state && icon_hippie)
        check_hippie_icon()
    return ..()

////////////////////
/////SPRITE ACC/////
////////////////////

/datum/sprite_accessory/ears/tcat
	name = "TCat"
	icon_hippie = 'hippiestation/icons/mob/mutant_bodyparts.dmi'
	icon_state = "tcat"

/datum/sprite_accessory/tails/human/tcat
	name = "TCat"
	icon_hippie = 'hippiestation/icons/mob/mutant_bodyparts.dmi'
	icon_state = "tcat"

/datum/sprite_accessory/tails_animated/human/tcat
	name = "TCat"
	icon_hippie = 'hippiestation/icons/mob/mutant_bodyparts.dmi'
	icon_state = "tcat"

/datum/sprite_accessory/screen
	icon_hippie = 'hippiestation/icons/mob/mutant_bodyparts.dmi'
	color_src = null

/datum/sprite_accessory/screen/sunburst
	name = "Sunburst"
	icon_state = "sunburst"

/datum/sprite_accessory/screen/sunburst
	name = "Harm"
	icon_state = "harm"

/datum/sprite_accessory/screen/sunburst
	name = "Help"
	icon_state = "help"

/datum/sprite_accessory/screen/sunburst
	name = "Rainbow"
	icon_state = "rainbow"

/datum/sprite_accessory/screen/sunburst
	name = "Blaze"
	icon_state = "blaze"

/datum/sprite_accessory/screen/static
	name = "Static"
	icon_state = "static"


////////////////////
/////HAIRSTYLES/////
////////////////////

/datum/sprite_accessory/hair/hippie/
	icon_hippie = 'hippiestation/icons/mob/human_face.dmi'

/datum/sprite_accessory/hair/hippie/birdnest
	name = "Birdnest"
	icon_state = "hair_birdnest"

/datum/sprite_accessory/hair/hippie/unkept
	name = "Unkept"
	icon_state = "hair_unkept"

/datum/sprite_accessory/hair/hippie/duelist
	name = "Duelist"
	icon_state = "hair_duelist"

/datum/sprite_accessory/hair/hippie/fastline
	name = "Fastline"
	icon_state = "hair_fastline"

/datum/sprite_accessory/hair/hippie/modern
	name = "Modern"
	icon_state = "hair_modern"

/datum/sprite_accessory/hair/hippie/quadcurls	//weaboo supreme
	name = "Quadcurls"
	icon_state = "hair_quadcurls"

/datum/sprite_accessory/hair/hippie/rapunzel
	name = "Rapunzel"
	icon_state = "hair_rapunzel"

/datum/sprite_accessory/hair/hippie/unshaven_mohawk
	name = "Unshaven Mohawk"
	icon_state = "hair_unshavenmohawk"

/datum/sprite_accessory/hair/hippie/twincurl
	name = "Twincurls"
	icon_state = "hair_twincurl"

/datum/sprite_accessory/hair/hippie/twincurl_alt
	name = "Upper Twincurls"
	icon_state = "hair_twincurl2"