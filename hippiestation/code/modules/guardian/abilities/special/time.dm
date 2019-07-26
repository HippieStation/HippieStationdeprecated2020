/datum/guardian_ability/major/special/timestop
	name = "Time Stop"
	desc = "The stand can stop time in a localized area."
	cost = 5
	spell_type = /obj/effect/proc_holder/spell/aoe_turf/conjure/timestop/stand

/obj/effect/proc_holder/spell/aoe_turf/conjure/timestop/stand
	invocation_type = "none"
	clothes_req = FALSE
	staff_req = FALSE
	summon_type = list(/obj/effect/timestop)
