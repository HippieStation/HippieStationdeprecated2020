/obj/effect/proc_holder
	var/action_background_icon = 'icons/mob/actions/backgrounds.dmi'

/obj/effect/proc_holder/spell
	action_background_icon = 'icons/mob/actions/backgrounds.dmi'

/datum/action/spell_action/New(Target)
	..()
	var/obj/effect/proc_holder/spell/S = Target
	icon_icon = S.action_icon
	button_icon = S.action_background_icon
