/datum/status_effect/avenger
	id = "avenger"
	duration = 125

/datum/status_effect/avenger/tick()
	owner.adjustBruteLoss(-1.5)
	owner.adjustFireLoss(-1.5)
	owner.adjustOxyLoss(-2)


/datum/status_effect/agent_pinpointer/avenger
	id = "avenger_pinpointer"
	minimum_range = 1
	range_fuzz_factor = 0
	tick_interval = 10
	alert_type = /obj/screen/alert/status_effect/agent_pinpointer/avenger

/datum/status_effect/agent_pinpointer/gauntlet/scan_for_target()
	scan_target = locate(/obj/item/badmin_gauntlet) in world

/obj/screen/alert/status_effect/agent_pinpointer/avenger
	name = "Avengers Pinpointer"
