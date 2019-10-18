/datum/magic/ritualism/sparks
	name = "Summon Sparks"
	complexity = 2
	layers = list(list(/datum/magic_trait/light, /datum/magic_trait/fire), list(/datum/magic_trait/light))

/datum/magic/ritualism/sparks/misfire(mob/living/firer, turf/center, amped)
	if(amped)
		explosion(center, 0, 0, 5, 7, flame_range = 6)
	else
		center.atmos_spawn_air("plasma=50;TEMP=1000")

/datum/magic/ritualism/sparks/fire(mob/living/firer, turf/center, amped)
	do_sparks(5, center, src)
