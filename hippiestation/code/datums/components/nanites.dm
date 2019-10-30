/datum/component/nanites/RegisterWithParent()
	..()
	if(isliving(parent))
		RegisterSignal(parent, COMSIG_MOB_EMOTE, .proc/on_emote)

/datum/component/nanites/proc/on_emote(datum/source, emote)
	for(var/X in programs)
		var/datum/nanite_program/NP = X
		NP.on_emote(emote)

/datum/component/nanites/UnregisterFromParent()
	..()
	UnregisterSignal(parent, COMSIG_MOB_EMOTE)