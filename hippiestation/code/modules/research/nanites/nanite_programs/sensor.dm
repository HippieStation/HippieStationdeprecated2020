/datum/nanite_program/sensor/emote
	name = "Emote Sensor"
	desc = "The nanites send a signal whenever the host does a certain emote."
	extra_settings = list("Sent Code", "Emote")
	var/emote = "wink"

/datum/nanite_program/sensor/emote/get_extra_setting(setting)
	if(setting == "Sent Code")
		return sent_code
	if(setting == "Emote")
		return emote

/datum/nanite_program/sensor/emote/set_extra_setting(user, setting)
	if(setting == "Sent Code")
		var/new_code = input(user, "Set the sent code (1-9999):", name, null) as null|num
		if(isnull(new_code))
			return
		sent_code = CLAMP(round(new_code, 1), 1, 9999)
	if(setting == "Emote")
		var/new_emote = replacetext(replacetext(lowertext(input("Enter the emote you'd like to detect.", "Input") as text), " ", ""), "*", "")
		if(isnull(new_emote))
			return
		emote = new_emote

/datum/nanite_program/sensor/emote/copy_extra_settings_to(datum/nanite_program/sensor/emote/target)
	target.sent_code = sent_code
	target.emote = emote

/datum/nanite_program/sensor/emote/on_emote(sent_emote)
	if(emote == sent_emote)
		send_code()