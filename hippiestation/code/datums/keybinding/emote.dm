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


/datum/keybinding/emote/flip
	hotkey_keys = list("Unbound")
	name = "flip"
	full_name = "Flip"
	description = "I'm going to jump! No!- DO A FLIP!"

/datum/keybinding/emote/spin
	hotkey_keys = list("Unbound")
	name = "spin"
	full_name = "Spin"
	description = "Spin me right round baby, right round."
