/datum/action/innate/cult/blood_magic/Positioning()
	return

/datum/action/innate/cult/blood_magic/Grant()
	return ...() // call parent of parent, disabling the shitty initial positioning

/datum/action/item_action/cult_dagger/Grant(mob/M)
	if(iscultist(M))
		return ...()
	else
		Remove(owner)
