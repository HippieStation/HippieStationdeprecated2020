/datum/magic/invoke/sparks
	name = "Summon Sparks"
	complexity = 3
	possible_words = list("spark", "scintilla", "accendo", "kindle", "incito", "ignesco")

/datum/magic/invoke/sparks/fire(mob/living/firer, amped)
	do_sparks(amped ? 6 : 3, TRUE, firer)

/datum/magic/invoke/sparks/misfire(mob/living/firer, amped)
	firer.fire_stacks += amped ? 5 : 2
	firer.IgniteMob()
