/datum/action/innate/cult/blood_magic/Positioning()
	return FALSE

/datum/action/innate/cult/blood_magic/Grant(mob/M)
	return call(src, /datum/action/innate.proc/Grant)(M)

/datum/action/item_action/cult_dagger/Grant(mob/M)
	if(iscultist(M))
		return call(src, /datum/action/item_action.proc/Grant)(M)
	else
		Remove(owner)
