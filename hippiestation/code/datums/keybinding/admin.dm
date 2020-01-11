/datum/keybinding/admin/mentor_say
	hotkey_keys = list("F4")
	name = "mentor_say"
	full_name = "Msay"
	description = "Mentor say"

/datum/keybinding/admin/mentor_say/down(client/user)
	user.get_mentor_say()
	return TRUE
