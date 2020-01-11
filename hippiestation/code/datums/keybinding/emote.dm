/datum/keybinding/emote
	category = CATEGORY_EMOTE
	weight = WEIGHT_EMOTE

/datum/keybinding/emote/down(client/user)
	. = ..()
	user.mob.emote(name)

/datum/keybinding/emote/scream
	hotkey_keys = list("CtrlS")
	name = "scream"
	full_name = "Scream"
	description = "REEEEEEEEEEEEEEEEEEEEEEEE!"

/datum/keybinding/emote/fart
	hotkey_keys = list("CtrlF")
	name = "fart"
	full_name = "Fart"
	description = "Uh oh, stinky!"
