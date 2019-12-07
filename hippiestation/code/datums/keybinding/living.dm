/datum/keybinding/living/scream
	hotkey_keys = list("CtrlS")
	name = "scream"
	full_name = "Scream"
	description = "Scream"

/datum/keybinding/living/scream/down(client/user)
	var/mob/living/L = user.mob
	L.emote("scream")
	return TRUE

/datum/keybinding/living/fart
	hotkey_keys = list("CtrlF")
	name = "fart"
	full_name = "Fart"
	description = "Fart"

/datum/keybinding/living/fart/down(client/user)
	var/mob/living/L = user.mob
	L.emote("fart")
	return TRUE
