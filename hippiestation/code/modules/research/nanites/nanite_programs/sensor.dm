/datum/nanite_program/sensor/emote
	name = "Emote Sensor"
	desc = "The nanites send a signal whenever the host does a certain emote."

/datum/nanite_program/sensor/emote/on_mob_add()
	. = ..()
	RegisterSignal(host_mob, COMSIG_MOB_EMOTE, .proc/on_emote)

/datum/nanite_program/sensor/emote/on_mob_remove()
	UnregisterSignal(host_mob, COMSIG_MOB_EMOTE)

/datum/nanite_program/sensor/emote/register_extra_settings()
	. = ..()
	extra_settings[NES_EMOTE] = new /datum/nanite_extra_setting/text("wink")

/datum/nanite_program/sensor/emote/proc/on_emote(sent_emote)
	var/datum/nanite_extra_setting/emote = extra_settings[NES_EMOTE]
	if(sent_emote == emote.get_value())
		send_code()
