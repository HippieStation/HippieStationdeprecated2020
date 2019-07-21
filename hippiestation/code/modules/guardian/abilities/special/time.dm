
/*/datum/guardian_ability/major/special/timestop
	name = "Time Stop"
	desc = "The stand can stop time for 10 seconds."
	cost = 5
	arrow_weight = 1.5
	spell_type = /obj/effect/proc_holder/spell/self/the_world

/datum/guardian_ability/major/special/timestop/Apply()
	. = ..()
	var/obj/effect/proc_holder/spell/self/the_world/S = spell
	if(S && istype(S))
		S.seconds = 10 SECONDS
*/
