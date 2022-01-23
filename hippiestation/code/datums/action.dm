/datum/action/item_action/change_tool
	name = "Change Holotool Setting"

/datum/action/item_action/change_ht_color
	name = "Change Holotool Color"

/datum/action/item_action/special_attack
	button_icon = 'hippiestation/icons/mob/actions.dmi' //This is the file for the BACKGROUND icon
	background_icon_state = "bg_special" //And this is the state for the background icon

/datum/action/item_action/special_attack/New()
	..()
	if(target)
		var/obj/item/I = target
		name = I.special_name
		desc = I.special_desc

/datum/action/item_action/special_attack/Trigger()
	UpdateButtonIcon()
	if(target)
		var/obj/item/I = target
		if(I.special_attack)
			I.special_attack = FALSE
			to_chat(owner, "You disable [I]'s special attack")
		else
			I.special_attack = TRUE
			to_chat(owner, "You enable [I]'s special attack")

/datum/action/item_action/toggle_stick
	name = "Get Hockey Stick"

/datum/action/item_action/make_puck
	name = "Fabricate Holopack"

/datum/action/item_action/dusting_implant
	check_flags =  NONE
	name = "Activate Dusting Implant"
	icon_icon = 'icons/effects/blood.dmi'
	button_icon_state = "remains"
